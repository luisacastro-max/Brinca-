import 'package:app_twins/api_config.dart';
import 'package:app_twins/services/service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PremiumPlanItem {
  const PremiumPlanItem({
    required this.id,
    required this.code,
    required this.name,
    required this.shortDescription,
    required this.audienceDescription,
    required this.features,
    required this.ctaLabel,
    required this.ctaType,
    required this.priceInCents,
    required this.currency,
    required this.interval,
  });

  final String id;
  final String code;
  final String name;
  final String shortDescription;
  final String audienceDescription;
  final List<String> features;
  final String ctaLabel;
  final String ctaType;
  final int priceInCents;
  final String currency;
  final String interval;

  bool get isCheckout => ctaType == 'checkout';
}

class PremiumPlansPageService {
  PremiumPlansPageService({SubscriptionPlansApi? subscriptionPlansApi})
    : _subscriptionPlansApi =
          subscriptionPlansApi ?? ServiceSdk.instance.subscriptionPlans;

  final SubscriptionPlansApi _subscriptionPlansApi;

  Future<List<PremiumPlanItem>> loadPlans() async {
    final plans = await _subscriptionPlansApi.getSubscriptionPlans();

    final mapped = plans
        .map((json) {
          final id = (json['_id'] ?? json['id'] ?? '').toString().trim();
          if (id.isEmpty) return null;

          final features = _asStringList(json['features']);

          return PremiumPlanItem(
            id: id,
            code: (json['code'] ?? '').toString(),
            name: (json['name'] ?? 'Plano').toString(),
            shortDescription: (json['shortDescription'] ?? '').toString(),
            audienceDescription: (json['audienceDescription'] ?? '').toString(),
            features: features,
            ctaLabel: (json['ctaLabel'] ?? 'Fazer contato').toString(),
            ctaType: (json['ctaType'] ?? 'contact').toString(),
            priceInCents: _asInt(json['priceInCents']),
            currency: (json['currency'] ?? 'brl').toString(),
            interval: (json['interval'] ?? 'month').toString(),
          );
        })
        .whereType<PremiumPlanItem>()
        .toList();

    return mapped;
  }

  Future<void> checkoutPlan(PremiumPlanItem plan) async {
    try {
      if (!plan.isCheckout) {
        throw const ServiceException(
          statusCode: 400,
          message: 'Este plano nao possui checkout direto no app.',
        );
      }

      if (ApiConfig.stripePublishableKey.trim().isEmpty) {
        throw const ServiceException(
          statusCode: 500,
          message:
              'Stripe nao configurado no app. Defina STRIPE_PUBLISHABLE_KEY no build.',
        );
      }

      Stripe.publishableKey = ApiConfig.stripePublishableKey;

      final payload = await _subscriptionPlansApi.createPaymentIntent(
        planId: plan.id,
      );
      print('Payload do PaymentIntent: $payload');

      final clientSecret = (payload['clientSecret'] ?? '').toString().trim();
      print('ClientSecret do PaymentIntent: $clientSecret');
      if (clientSecret.isEmpty) {
        throw const ServiceException(
          statusCode: 500,
          message: 'clientSecret nao retornado pelo backend.',
        );
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Brinca+',
        ),
      );
      print('PaymentSheet inicializado com sucesso.');

      await Stripe.instance.presentPaymentSheet();
      print('PaymentSheet apresentado ao usuario.');
    } catch (e) {
      print('Erro durante o processo de checkout: $e');
      rethrow;
    }
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return const <String>[];
  }
}
