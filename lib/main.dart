import 'package:expense_tracker/expenses_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  final themeColor = const Color.fromARGB(255, 10, 24, 78);

  @override
  Widget build(BuildContext context) {
    final kColorScheme = ColorScheme.fromSeed(
        brightness: Brightness.dark, seedColor: themeColor);

    return MaterialApp(
      home: const ExpensesScreen(),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: themeColor,
            foregroundColor: kColorScheme.inverseSurface),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.onPrimaryContainer,
                foregroundColor: kColorScheme.onPrimary)),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
        ),
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
    );
  }
}
