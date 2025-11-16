import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const WasteVisionApp());
}

class WasteVisionApp extends StatelessWidget {
  const WasteVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WasteVision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const HomePage(),
      },
    );
  }
}
