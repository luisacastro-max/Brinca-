// lib/api_config.dart

/// Endereço base do backend Node.js em rede local.
/// Ajuste o IP/porta conforme necessário. Use "https://" se o servidor
/// suportar HTTPS.
class ApiConfig {
  static const String baseUrl = 'https://brincamais-api.onrender.com';

  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: '',
  );
}
