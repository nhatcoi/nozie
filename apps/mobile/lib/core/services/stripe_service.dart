import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../network/api_exception.dart';
import '../network/api_response.dart';
import '../network/providers.dart';

final stripeServiceProvider = Provider<StripeService>((ref) => StripeService(ref.watch(dioProvider)));

/// Client side of a purchase. Price and currency are decided by the server from its catalog, and the purchase is
/// granted only when Stripe confirms the payment to the server's webhook; the app merely shows the payment sheet.
class StripeService {
  StripeService(this._dio);

  final Dio _dio;

  /// Creates a payment intent for [movieId]. The user is identified by the access token, never by the request body.
  Future<PaymentIntentResponse> createPaymentIntent({required String movieId}) async {
    final res = await guardApi(() => _dio.post<dynamic>('/payments/intents', data: {'movieId': movieId}));
    return PaymentIntentResponse.fromJson(res.payloadMap);
  }

  Future<void> presentPaymentSheet({
    required String clientSecret,
    required String ephemeralKeySecret,
    required String customerId,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Nozie',
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKeySecret,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        throw Exception('Payment canceled');
      }
      throw Exception('Payment failed: ${e.error.message}');
    } catch (e) {
      throw Exception('Payment error: $e');
    }
  }

  Future<TransactionStatus> getTransactionStatus(String transactionId) async {
    final res = await guardApi(() => _dio.get<dynamic>('/payments/$transactionId'));
    return TransactionStatus.fromJson(res.payloadMap);
  }
}

class PaymentIntentResponse {
  PaymentIntentResponse({
    required this.clientSecret,
    required this.ephemeralKey,
    required this.customerId,
    required this.transactionId,
  });

  final String clientSecret;
  final String ephemeralKey;
  final String customerId;
  final String transactionId;

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) {
    String field(String key) {
      final v = json[key];
      if (v is! String || v.isEmpty) {
        throw ApiException(code: 'UNKNOWN', message: 'Payment response is missing "$key"');
      }
      return v;
    }

    return PaymentIntentResponse(
      clientSecret: field('clientSecret'),
      ephemeralKey: field('ephemeralKey'),
      customerId: field('customerId'),
      transactionId: field('transactionId'),
    );
  }
}

class TransactionStatus {
  TransactionStatus({required this.id, required this.status, this.paidAt, this.errorMessage});

  final String id;

  /// Lower-case: `pending`, `succeeded`, `failed`, `canceled`.
  final String status;
  final DateTime? paidAt;
  final String? errorMessage;

  factory TransactionStatus.fromJson(Map<String, dynamic> json) => TransactionStatus(
        id: json['id'] as String? ?? '',
        status: (json['status'] as String? ?? 'PENDING').toLowerCase(),
        paidAt: json['paidAt'] is String ? DateTime.tryParse(json['paidAt'] as String) : null,
        errorMessage: json['errorMessage'] as String?,
      );

  bool get isSuccess => status == 'succeeded';
  bool get isFailed => status == 'failed';
  bool get isCanceled => status == 'canceled';
  bool get isPending => status == 'pending';
}
