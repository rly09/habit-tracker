import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:habitus/database/tables.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, HabitEntries, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Habit>> watchAllHabits() {
    return (select(habits)..orderBy([(t) => OrderingTerm(expression: t.createdAt)])).watch();
  }

  Future<int> addHabit(String name) {
    return into(habits).insert(HabitsCompanion(name: Value(name)));
  }

  Future<int> deleteHabit(int id) {
    return (delete(habits)..where((t) => t.id.equals(id))).go();
  }

  Future<void> updateHabitName(int id, String newName) {
    return (update(habits)..where((t) => t.id.equals(id))).write(HabitsCompanion(name: Value(newName)));
  }

  Stream<List<HabitEntry>> watchHabitEntries(int habitId) {
    return (select(habitEntries)..where((t) => t.habitId.equals(habitId))).watch();
  }

  Future<int> addHabitEntry(int habitId, DateTime date) {
    return into(habitEntries).insert(HabitEntriesCompanion(
      habitId: Value(habitId),
      completedDate: Value(date),
    ));
  }

  Future<int> removeHabitEntry(int habitId, DateTime date) {
    return (delete(habitEntries)
      ..where((t) => t.habitId.equals(habitId) & t.completedDate.equals(date)))
      .go();
  }

   Future<void> toggleHabit(int habitId, DateTime date) async {
    final entry = await (select(habitEntries)
      ..where((t) => t.habitId.equals(habitId) & t.completedDate.equals(date)))
      .getSingleOrNull();

    if (entry != null) {
      await removeHabitEntry(habitId, date);
    } else {
      await addHabitEntry(habitId, date);
    }
  }

  Future<Setting?> getSettings() {
    return select(settings).getSingleOrNull();
  }

  Stream<Setting?> watchSettings() {
    return select(settings).watchSingleOrNull();
  }

  Stream<List<HabitEntry>> watchAllHabitEntries() {
    return select(habitEntries).watch();
  }

  Future<void> updateFirstLaunchDate(DateTime date) async {
    final setting = await getSettings();
    if (setting == null) {
      into(settings).insert(SettingsCompanion(firstLaunchDate: Value(date)));
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
