class AppConfig {
  /// عنوان السيرفر. للتشغيل على جهاز حقيقي/إنتاج:
  ///   flutter run --dart-define=API_URL=https://api.your-domain.com
  /// محاكي أندرويد: 10.0.2.2  |  محاكي iOS: localhost
  static const String baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:3000');

  /// يحوّل مسار الأيقونة النسبي (مثل /icons/rose.png) إلى رابط كامل
  static String resolveUrl(String url) =>
      url.startsWith('http') ? url : '$baseUrl$url';
}
