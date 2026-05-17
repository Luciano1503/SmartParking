class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://smartparking-production-9a89.up.railway.app',
  );

  static const String companyPortalUrl = String.fromEnvironment(
    'COMPANY_PORTAL_URL',
    defaultValue: 'https://smart-parking-mlma.vercel.app/login',
  );

  static const String _parkingSocketOverride = String.fromEnvironment(
    'WS_PARKING_URL',
    defaultValue: '',
  );

  static String get parkingSocketUrl {
    if (_parkingSocketOverride.isNotEmpty) return _parkingSocketOverride;

    final apiUri = Uri.parse(baseUrl);
    final socketScheme = apiUri.scheme == 'https' ? 'wss' : 'ws';
    return apiUri.replace(scheme: socketScheme, path: '/ws/parking').toString();
  }

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'AIzaSyDU9V_Db6UdM8vuvfQwSghwRdT3v-cOklk',
  );
}
