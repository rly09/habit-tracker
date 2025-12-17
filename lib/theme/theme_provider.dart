import 'package:flutter/material.dart';
import 'package:habitus/database/app_database.dart';

class ThemeProvider extends ChangeNotifier {
  final AppDatabase _database;

  ThemeProvider(this._database);

  ThemeMode get themeMode => ThemeMode.light;

  bool get isDarkMode => false;
}
