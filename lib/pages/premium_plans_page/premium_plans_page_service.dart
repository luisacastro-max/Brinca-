import 'package:app_twins/api_config.dart';
import 'package:app_twins/services/core/backend_session_store.dart';
import 'package:app_twins/services/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:url_launcher/url_launcher.dart';

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

      if (kIsWeb) {
        await _checkoutPlanWeb(plan);
        return;
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

      final clientSecret = (payload['clientSecret'] ?? '').toString().trim();
      final paymentIntentId = (payload['paymentIntentId'] ?? '').toString().trim();

      if (clientSecret.isEmpty) {
        throw const ServiceException(
          statusCode: 500,
          message: 'clientSecret nao retornado pelo backend.',
        );
      }
      if (paymentIntentId.isEmpty) {
        throw const ServiceException(
          statusCode: 500,
          message: 'paymentIntentId nao retornado pelo backend.',
        );
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Brinca+',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      await _subscriptionPlansApi.activatePremium(
        paymentIntentId: paymentIntentId,
      );
      await _refreshCurrentUserInSessionStore();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> processWebCheckoutReturn() async {
    if (!kIsWeb) return null;

    final checkoutResult = Uri.base.queryParameters['checkout_result'];
    final checkoutSessionId =
        (Uri.base.queryParameters['checkout_session_id'] ?? '').trim();

    if (checkoutResult == null || checkoutResult.isEmpty) {
      return null;
    }

    if (checkoutResult == 'cancel') {
      return 'Pagamento cancelado.';
    }

    if (checkoutResult != 'success' || checkoutSessionId.isEmpty) {
      return 'Nao foi possivel validar o pagamento.';
    }

    await _subscriptionPlansApi.activatePremiumFromCheckoutSession(
      checkoutSessionId: checkoutSessionId,
    );
    await _refreshCurrentUserInSessionStore();
    return 'Pagamento concluido com sucesso.';
  }

  Future<void> _checkoutPlanWeb(PremiumPlanItem plan) async {
    final successUrl = _buildWebReturnUrl(result: 'success');
    final cancelUrl = _buildWebReturnUrl(result: 'cancel');

    final payload = await _subscriptionPlansApi.createCheckoutSession(
      planId: plan.id,
      successUrl: successUrl,
      cancelUrl: cancelUrl,
    );

    final checkoutUrl = (payload['checkoutUrl'] ?? '').toString().trim();
    if (checkoutUrl.isEmpty) {
      throw const ServiceException(
        statusCode: 500,
        message: 'checkoutUrl nao retornada pelo backend.',
      );
    }

    final opened = await launchUrl(
      Uri.parse(checkoutUrl),
      webOnlyWindowName: '_self',
    );

    if (!opened) {
      throw const ServiceException(
        statusCode: 500,
        message: 'Nao foi possivel abrir o checkout no navegador.',
      );
    }
  }

  String _buildWebReturnUrl({required String result}) {
    final query = Map<String, String>.from(Uri.base.queryParameters)
      ..remove('checkout_result')
      ..remove('checkout_session_id')
      ..['checkout_result'] = result;

    return Uri.base.replace(queryParameters: query).toString();
  }

  Future<void> _refreshCurrentUserInSessionStore() async {
    final profile = await ServiceSdk.instance.users.getCurrentUserProfile();
    if (profile == null) return;
    await BackendSessionStore.instance.saveUser(profile);
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
