class TransactionItem {
  final String id;
  final String userId;
  final String movieId;
  final String? movieTitle;
  final String? movieImageUrl;
  final String? movieSlug;
  final double amount;
  final String currency;
  final String status;
  final DateTime? createdAt;
  final DateTime? paidAt;
  final DateTime? failedAt;
  final DateTime? canceledAt;
  final String? stripePaymentIntentId;
  final String? chargeId;
  final String? errorMessage;

  const TransactionItem({
    required this.id,
    required this.userId,
    required this.movieId,
    this.movieTitle,
    this.movieImageUrl,
    this.movieSlug,
    required this.amount,
    this.currency = 'usd',
    required this.status,
    this.createdAt,
    this.paidAt,
    this.failedAt,
    this.canceledAt,
    this.stripePaymentIntentId,
    this.chargeId,
    this.errorMessage,
  });

  /// From the API's `TransactionResponse`. Stripe ids are deliberately not exposed by the server.
  factory TransactionItem.fromApi(Map<String, dynamic> json) {
    DateTime? date(dynamic v) => v is String ? DateTime.tryParse(v)?.toLocal() : null;
    final status = (json['status'] as String? ?? 'PENDING').toLowerCase();
    return TransactionItem(
      id: json['id'] as String? ?? '',
      userId: '',
      movieId: json['movieId'] as String? ?? '',
      amount: ((json['amountCents'] as num?)?.toDouble() ?? 0.0) / 100.0,
      currency: (json['currency'] as String? ?? 'USD').toLowerCase(),
      status: status,
      createdAt: date(json['createdAt']),
      paidAt: date(json['paidAt']),
      errorMessage: json['errorMessage'] as String?,
    );
  }

  bool get isSuccess => status == 'succeeded';
  bool get isFailed => status == 'failed';
  bool get isCanceled => status == 'canceled';
  bool get isPending => status == 'pending';
}
