import 'dart:html' as html;

void clearCheckoutReturnQueryParams() {
  final currentUri = Uri.base;
  final updatedQuery = Map<String, String>.from(currentUri.queryParameters)
    ..remove('checkout_result')
    ..remove('checkout_session_id');

  final cleanedUri = currentUri.replace(queryParameters: updatedQuery);
  html.window.history.replaceState(null, '', cleanedUri.toString());
}