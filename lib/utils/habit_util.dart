import 'package:habitus/database/app_database.dart';

bool isHabitCompletedToday(List<HabitEntry> entries) {
  final today = DateTime.now();
  return entries.any(
    (entry) =>
        entry.completedDate.year == today.year &&
        entry.completedDate.month == today.month &&
        entry.completedDate.day == today.day,
  );
}

Map<DateTime, int> prepHeatMapDataset(List<HabitEntry> entries) {
  Map<DateTime, int> dataset = {};

  for (var entry in entries) {
    final normalizedDate = DateTime(
      entry.completedDate.year,
      entry.completedDate.month,
      entry.completedDate.day,
    );
    if (dataset.containsKey(normalizedDate)) {
      dataset[normalizedDate] = dataset[normalizedDate]! + 1;
    } else {
      dataset[normalizedDate] = 1;
    }
  }
  return dataset;
}
