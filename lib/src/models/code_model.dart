class Code {
  final String reservationID;
  final String code;
  final String pinCode;

  Code(
      {required this.reservationID, required this.code, required this.pinCode});

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      reservationID: json['ReservationID'],
      code: json['Code'],
      pinCode: json['PINCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ReservationID': reservationID,
      'Code': code,
      'PINCode': pinCode,
    };
  }
}
