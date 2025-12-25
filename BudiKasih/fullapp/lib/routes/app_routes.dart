import 'package:flutter/material.dart';
import '../pages/welcome/welcome_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/dashboard/homepage.dart';
import '../pages/dashboard/donation/donasi_barang_page.dart';
import '../pages/dashboard/donation/donasi_tunai_page.dart';
import '../pages/dashboard/profile/profile_page.dart';
import '../pages/dashboard/notification/notification_page.dart';
import '../pages/auth/setting_pass_page.dart';
import '../pages/dashboard/profile/donation_history_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
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
  };
}