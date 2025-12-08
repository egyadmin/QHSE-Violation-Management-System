/// API Configuration
class AppConstants {
  // API Base URL - Development with Public Endpoints
  static const String baseUrl = 'https://2fbc074f-4ec4-4da4-9211-60501eb8a27a-00-3jpu4qdhzoiii.pike.replit.dev';
  static const String apiKey = 'QHSE2025\$ecure@API';
  
  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Local Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'app_language';
  
  // Supported Locales
  static const String arabicLocale = 'ar';
  static const String englishLocale = 'en';
  static const String defaultLocale = arabicLocale;
  
  // Image Upload
  static const int maxImageSizeMB = 5;
  static const int imageQuality = 85;
  
  // Map Configuration
  static const double defaultLatitude = 24.7136;  // Riyadh
  static const double defaultLongitude = 46.6753; // Riyadh
  static const double defaultZoom = 13.0;
  
  // Timezone
  static const String riyadhTimezone = 'Asia/Riyadh';
}
