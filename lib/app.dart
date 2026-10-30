import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/universities/presentation/screens/universities_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Universidades',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const UniversitiesScreen(),
    );
  }
}
