import 'package:drift/drift.dart';

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class HabitEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer().references(Habits, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get completedDate => dateTime()();
  TextColumn get note => text().nullable()();
}

class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get firstLaunchDate => dateTime().nullable()();
}
