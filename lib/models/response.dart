class SmsReport {
  String status;
  String message;
  String messageId;
  double cost;
  String currency;
  String gatewayUsed;

  SmsReport({
    required this.status,
    required this.message,
    required this.messageId,
    required this.cost,
    required this.currency,
    required this.gatewayUsed,
  });

  factory SmsReport.fromJson(Map json) {
    return SmsReport(
      status: json['data']['status'],
      message: json['data']['message'],
      messageId: json['data']['message_id'],
      cost: json['data']['cost'],
      currency: json['data']['currency'],
      gatewayUsed: json['data']['gateway_used'],
    );
  }

  // static SmsReport fromJson(Map json) {
  //   return SmsReport(
  //     status: json['data']['status'],
  //     message: json['data']['message'],
  //     messageId: json['data']['message_id'],
  //     cost: json['data']['cost'],
  //     currency: json['data']['currency'],
  //     gatewayUsed: json['data']['gateway_used'],
  //   );
  // }
}
