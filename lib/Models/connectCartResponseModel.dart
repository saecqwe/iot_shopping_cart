class ConnectCartResponseModel {
  final String message;
  final String specialCode;

  ConnectCartResponseModel({
    required this.message,
    required this.specialCode,
  });

  factory ConnectCartResponseModel.fromJson(Map<String, dynamic> json) {
    return ConnectCartResponseModel(
      message: json['message'],
      specialCode: json['dispCart']['_id'],
    );
  }
}
