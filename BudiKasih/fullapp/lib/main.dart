import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Controllers
import 'controllers/auth_controller.dart';
import 'controllers/donasi_controller.dart';
import 'controllers/notifikasi_controller.dart';

// Services
import 'services/auth_service.dart'; // ✅ Sudah di-import

// Pages
import 'pages/welcome/welcome_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/signup_page.dart';
import 'pages/dashboard/homepage.dart';
import 'pages/dashboard/donation/donasi_barang_page.dart';
import 'pages/dashboard/donation/donasi_tunai_page.dart';
import 'pages/dashboard/profile/profile_page.dart';
import 'pages/dashboard/notification/notification_page.dart';
import 'pages/auth/setting_pass_page.dart';
import 'pages/dashboard/profile/donation_history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://omlrnxdqdfxfaypaarho.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9tbHJueGRxZGZ4ZmF5cGFhcmhvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY3NTk0NjgsImV4cCI6MjA4MjMzNTQ2OH0.vMacOJc_XN70HN7Drmni7VqveHC7vj_-VthvUBAeYfU',
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ✅ TAMBAHKAN AuthService DI SINI:
        Provider<AuthService>(
          create: (_) => AuthService(),
          // Jika AuthService butuh inisialisasi async:
          // create: (_) => AuthService()..initialize(),
        ),
        
        // Controllers yang sudah ada:
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => DonasiController()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: MaterialApp(
        title: 'BudiKasih',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
          '/donationgoods': (context) => const DonationGoodsPage(),
          '/donationcash': (context) => const DonationCashPage(),
          '/profile': (context) => const ProfilePage(),
          '/notification': (context) => const NotificationPage(),
          '/setting_pass': (context) => const SettingPassPage(),
          '/history': (context) => const DonationHistoryPage(),
        },
      ),
    );
  }
}