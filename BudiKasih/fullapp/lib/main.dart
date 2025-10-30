import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

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
      routes: AppRoutes.routes,
      initialRoute: '/',
    );
  }
}