import 'package:flutter/material.dart';
import 'package:habitus/database/app_database.dart';
import 'package:habitus/pages/home_page.dart';
import 'package:habitus/theme/app_theme.dart';
import 'package:habitus/theme/theme_provider.dart';
import 'package:habitus/services/widget_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  await database.getSettings().then((settings) async {
    if (settings == null) {
      await database.updateFirstLaunchDate(DateTime.now());
    }
  });

  // Initialize home widget
  await WidgetService.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider(create: (context) => ThemeProvider(database)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HABITUS',
          home: const HomePage(),
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
