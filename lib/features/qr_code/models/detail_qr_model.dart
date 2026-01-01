class QrTokenResponse {
  final String token;
  final String memberId;

  QrTokenResponse({required this.token, required this.memberId});

  factory QrTokenResponse.fromJson(Map<String, dynamic> json) {
    return QrTokenResponse(
      token: json['token'] ?? '',
      memberId: json['memberId'] ?? '',
    );
  }
}