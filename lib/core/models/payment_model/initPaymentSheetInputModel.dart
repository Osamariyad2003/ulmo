class Initpaymentsheetinputmodel {
  final String clientSecret;
  final String ephemeralKeySecret;
  final String customerId;

  Initpaymentsheetinputmodel({
    required this.clientSecret,
    required this.ephemeralKeySecret,
    required this.customerId,
  });

  factory Initpaymentsheetinputmodel.fromJson(Map<String, dynamic> json) {
    return Initpaymentsheetinputmodel(
      clientSecret: json['clientSecret'],
      ephemeralKeySecret: json['ephemeralKeySecret'],
      customerId: json['customerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientSecret': clientSecret,
      'ephemeralKeySecret': ephemeralKeySecret,
      'customerId': customerId,
    };
  }
}
