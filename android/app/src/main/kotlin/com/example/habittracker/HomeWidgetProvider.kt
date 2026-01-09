package com.example.habittracker

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.widget.RemoteViews
import android.app.PendingIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONObject
import java.util.Calendar
import java.io.File
import java.io.FileOutputStream

class HomeWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = updateWidgetContent(context, widgetId, appWidgetManager)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun updateWidgetContent(
        context: Context,
        widgetId: Int,
        appWidgetManager: AppWidgetManager
    ): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.home_widget_layout)
        
        // Get widget dimensions
        val options = appWidgetManager.getAppWidgetOptions(widgetId)
        val minWidth = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)
        
        // Convert dp to pixels
        val density = context.resources.displayMetrics.density
        val widthPx = (minWidth * density).toInt()
        val heightPx = ((minHeight - 40) * density).toInt() // Subtract header height
        
        // Calculate grid size based on widget dimensions
        val gridSize = calculateGridSize(minWidth, minHeight)
        val daysToShow = gridSize.first * gridSize.second
        
        // Load heatmap data from SharedPreferences
        val widgetData = HomeWidgetPlugin.getData(context)
        val heatmapJson = widgetData.getString("heatmap_data", "{}")
        val heatmapData = parseHeatmapData(heatmapJson ?: "{}")
        
        // Update subtitle with date range
        views.setTextViewText(R.id.widget_subtitle, "Last $daysToShow days")
        
        // Generate heatmap bitmap
        val heatmapBitmap = generateHeatmapBitmap(
            context,
            heatmapData,
            gridSize,
            daysToShow,
            widthPx,
            heightPx
        )
        
        // Set the bitmap to ImageView
        views.setImageViewBitmap(R.id.heatmap_image, heatmapBitmap)
        
        // Set up click intent to open the app
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
        
        return views
    }

    private fun generateHeatmapBitmap(
        context: Context,
        data: Map<String, Int>,
        gridSize: Pair<Int, Int>,
        daysToShow: Int,
        widthPx: Int,
        heightPx: Int
    ): Bitmap {
        val columns = gridSize.first
        val rows = gridSize.second
        
        // Create bitmap
        val bitmap = Bitmap.createBitmap(
            maxOf(widthPx, 100),
            maxOf(heightPx, 100),
            Bitmap.Config.ARGB_8888
        )
        val canvas = Canvas(bitmap)
        
        // Background
        canvas.drawColor(Color.parseColor("#F5F5F5"))
        
        // Calculate cell dimensions
        val cellMargin = 2f
        val cellWidth = (widthPx.toFloat() - (columns + 1) * cellMargin) / columns
        val cellHeight = (heightPx.toFloat() - (rows + 1) * cellMargin) / rows
        
        // Get heatmap values
        val heatmapValues = getHeatmapValues(data, daysToShow)
        
        // Paint for cells
        val paint = Paint().apply {
            isAntiAlias = true
            style = Paint.Style.FILL
        }
        
        var index = 0
        
        // Draw cells
        for (row in 0 until rows) {
            for (col in 0 until columns) {
                if (index < heatmapValues.size) {
                    val x = cellMargin + col * (cellWidth + cellMargin)
                    val y = cellMargin + row * (cellHeight + cellMargin)
                    
                    paint.color = getColorForValue(heatmapValues[index])
                    
                    val rect = RectF(x, y, x + cellWidth, y + cellHeight)
                    canvas.drawRoundRect(rect, 4f, 4f, paint)
                    
                    index++
                }
            }
        }
        
        return bitmap
    }

    private fun getHeatmapValues(data: Map<String, Int>, daysToShow: Int): List<Int> {
        val values = mutableListOf<Int>()
        
        for (i in (daysToShow - 1) downTo 0) {
            val date = Calendar.getInstance()
            date.add(Calendar.DAY_OF_YEAR, -i)
            val dateKey = String.format(
                "%04d-%02d-%02d",
                date.get(Calendar.YEAR),
                date.get(Calendar.MONTH) + 1,
                date.get(Calendar.DAY_OF_MONTH)
            )
            values.add(data[dateKey] ?: 0)
        }
        
        return values
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: android.os.Bundle
    ) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        // Widget was resized, update the content
        val views = updateWidgetContent(context, appWidgetId, appWidgetManager)
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun calculateGridSize(widthDp: Int, heightDp: Int): Pair<Int, Int> {
        // Calculate number of columns and rows based on available space
        val cellSize = 16 // dp per cell including margin
        
        val columns = maxOf(5, minOf(14, widthDp / cellSize))
        val rows = maxOf(3, minOf(10, (heightDp - 40) / cellSize)) // 40dp for header
        
        return Pair(columns, rows)
    }

    private fun parseHeatmapData(jsonString: String): Map<String, Int> {
        val result = mutableMapOf<String, Int>()
        try {
            val jsonObject = JSONObject(jsonString)
            val keys = jsonObject.keys()
            while (keys.hasNext()) {
                val key = keys.next()
                result[key] = jsonObject.getInt(key)
            }
        } catch (e: Exception) {
            // Return empty map if parsing fails
        }
        return result
    }

    private fun getColorForValue(value: Int): Int {
        return when (value) {
            0 -> Color.parseColor("#E0E0E0") // Gray for no activity
            1 -> Color.parseColor("#C8E6C9") // Light green
            2 -> Color.parseColor("#81C784") // Medium-light green
            3 -> Color.parseColor("#4CAF50") // Medium green
            4 -> Color.parseColor("#388E3C") // Medium-dark green
            else -> Color.parseColor("#1B5E20") // Dark green for 5+
        }
    }

    companion object {
        fun updateWidget(context: Context) {
            val intent = Intent(context, HomeWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            }
            
            val ids = AppWidgetManager.getInstance(context)
                .getAppWidgetIds(android.content.ComponentName(context, HomeWidgetProvider::class.java))
            
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
            context.sendBroadcast(intent)
        }
    }
}
