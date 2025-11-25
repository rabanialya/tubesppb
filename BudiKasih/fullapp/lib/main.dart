import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const BudiKasihApp());
}

class BudiKasihApp extends StatelessWidget {
  const BudiKasihApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudiKasih',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routes: AppRoutes.routes,
      initialRoute: '/',
    );
  }
}