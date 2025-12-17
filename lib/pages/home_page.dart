import 'package:flutter/material.dart';
import 'package:habitus/components/my_habit_tile.dart';
import 'package:habitus/components/my_heat_map.dart';
import 'package:habitus/database/app_database.dart';
import 'package:habitus/theme/app_colors.dart';
import 'package:habitus/theme/theme_provider.dart';
import 'package:habitus/utils/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  void createNewHabit(AppDatabase database) {
    showDialog(
      context: context,
      builder: (context) => _buildDialog(
        title: "New Habit",
        hint: "Exercise, Read, etc.",
        onSave: () {
          if (textController.text.isNotEmpty) {
            database.addHabit(textController.text);
            Navigator.pop(context);
            textController.clear();
          }
        },
        onCancel: () {
          Navigator.pop(context);
          textController.clear();
        },
      ),
    );
  }

  void editHabit(AppDatabase database, Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => _buildDialog(
        title: "Edit Habit",
        hint: "Enter new name",
        onSave: () {
          if (textController.text.isNotEmpty) {
            database.updateHabitName(habit.id, textController.text);
            Navigator.pop(context);
            textController.clear();
          }
        },
        onCancel: () {
          Navigator.pop(context);
          textController.clear();
        },
      ),
    );
  }

  void deleteHabit(AppDatabase database, Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Habit?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              database.deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialog({
    required String title,
    required String hint,
    required VoidCallback onSave,
    required VoidCallback onCancel,
  }) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text("Cancel")),
        FilledButton(
          onPressed: onSave,
          child: const Text("Save"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("H A B I T U S"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewHabit(database),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<HabitEntry>>(
        stream: database.watchAllHabitEntries(),
        builder: (context, snapshotEntries) {
          final allEntries = snapshotEntries.data ?? [];
          final heatMapData = prepHeatMapDataset(allEntries);

          return StreamBuilder<List<Habit>>(
            stream: database.watchAllHabits(),
            builder: (context, snapshotHabits) {
              final habits = snapshotHabits.data ?? [];

              if (!snapshotHabits.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (habits.isEmpty) {
                return Center(
                  child: Text(
                    "No habits yet. Start today!",
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  // HeatMap
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MyHeatMap(
                      startDate: DateTime.now().subtract(const Duration(days: 60)), // Simplified start date
                      datasets: heatMapData,
                    ),
                  ),
                  
                  // Habits List
                  ...habits.map((habit) {
                    final habitEntries = allEntries.where((e) => e.habitId == habit.id).toList();
                    final isCompleted = isHabitCompletedToday(habitEntries);

                    return MyHabitTile(
                      text: habit.name,
                      isCompleted: isCompleted,
                      onChanged: (_) => database.toggleHabit(habit.id, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)),
                      editHabit: (_) => editHabit(database, habit),
                      deleteHabit: (_) => deleteHabit(database, habit),
                    );
                  }).toList(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
