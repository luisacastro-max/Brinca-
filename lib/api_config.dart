// lib/api_config.dart

/// Endereço base do backend Node.js em rede local.
/// Ajuste o IP/porta conforme necessário. Use "https://" se o servidor
/// suportar HTTPS.
class ApiConfig {
  static const String baseUrl = 'http://localhost:4000';

  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_51TQxYeK9xjNGoXJ1EBHWAWBYatfDOGEv929siZjZBorBC6P6IuTaCIH5ZhdEN2ODRournf4c8svuZBOwTH5GFSkU00a26WRezr',
  );
}
