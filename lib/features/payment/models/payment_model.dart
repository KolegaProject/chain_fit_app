class PaymentResponse {
  final int code;
  final String status;
  final int recordsTotal;
  final PaymentData data;
  final dynamic errors;

  PaymentResponse({
    required this.code,
    required this.status,
    required this.recordsTotal,
    required this.data,
    this.errors,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      recordsTotal: json['recordsTotal'] ?? 0,
      data: PaymentData.fromJson(json['data'] ?? {}),
      errors: json['errors'],
    );
  }
}

class PaymentData {
  final String token;
  final String redirectUrl;
  final int transactionId;
  final String orderId;
  final int grossAmount;
  final int adminFee;

  PaymentData({
    required this.token,
    required this.redirectUrl,
    required this.transactionId,
    required this.orderId,
    required this.grossAmount,
    required this.adminFee,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      token: json['token'] ?? '',
      redirectUrl: json['redirectUrl'] ?? '',
      transactionId: json['transactionId'] ?? 0,
      orderId: json['orderId'] ?? '',
      grossAmount: json['grossAmount'] ?? 0,
      adminFee: json['adminFee'] ?? 0,
    );
  }
}
