class ApiConfig {
  static const String baseUrl = 'http://192.168.1.4:8000/api';
  
  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  
  // Donasi
  static const String donasiPublic = 'donasi/public';
  static const String donasiStatistics = '/donasi/public/statistics';
  static const String donasi = '/donasi';
  static const String myDonations = 'donasi/my-donations';
  
  // Notifikasi
  static const String notifikasi = '/notifikasi';
  static const String notifikasiUnreadCount = '/notifikasi/unread-count';
  static String notifikasiMarkAsRead(int id) => '/notifikasi/$id/mark-as-read';
  static const String notifikasiMarkAllAsRead = '/notifikasi/mark-all-as-read';

    static const String feedback = 'feedback';
}