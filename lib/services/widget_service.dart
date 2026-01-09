import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:habitus/database/app_database.dart';

class WidgetService {
  /// Update the home widget with current heatmap data
  static Future<void> updateWidget(Map<DateTime, int> heatmapData) async {
    try {
      // Convert heatmap data to JSON format for the widget
      final widgetData = _prepareWidgetData(heatmapData);
      
      // Save data to SharedPreferences (accessible by native widget)
      await HomeWidget.saveWidgetData<String>('heatmap_data', widgetData);
      
      // Trigger widget update
      await HomeWidget.updateWidget(
        name: 'HomeWidgetProvider',
        androidName: 'HomeWidgetProvider',
      );
    } catch (e) {
      print('Error updating widget: $e');
    }
  }

  /// Prepare heatmap data in JSON format for the widget
  static String _prepareWidgetData(Map<DateTime, int> heatmapData) {
    // Convert DateTime keys to ISO8601 strings for JSON serialization
    final Map<String, int> jsonData = {};
    
    heatmapData.forEach((date, value) {
      final dateKey = date.toIso8601String().split('T')[0]; // YYYY-MM-DD format
      jsonData[dateKey] = value;
    });
    
    return jsonEncode(jsonData);
  }

  /// Initialize widget callbacks
  static Future<void> initialize() async {
    try {
      // Set up widget tap callback to open the app
      await HomeWidget.setAppGroupId('group.com.example.habittracker');
      
      // Register callback for widget taps
      HomeWidget.registerBackgroundCallback(_backgroundCallback);
    } catch (e) {
      print('Error initializing widget: $e');
    }
  }

  /// Background callback when widget is tapped
  static Future<void> _backgroundCallback(Uri? uri) async {
    // This will be called when the widget is tapped
    // The app will open automatically
  }

  /// Get the last N days of data for the widget
  static Map<DateTime, int> getLimitedHeatmapData(
    Map<DateTime, int> fullData,
    int maxDays,
  ) {
    final sortedEntries = fullData.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key)); // Sort by date descending
    
    final limitedEntries = sortedEntries.take(maxDays);
    return Map.fromEntries(limitedEntries);
  }
}
