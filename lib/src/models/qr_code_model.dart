class QRCode {
  final int qrCodeID;
  final int reservationID;
  final String code;
  final String pinCode;

  QRCode({
    required this.qrCodeID,
    required this.reservationID,
    required this.code,
    required this.pinCode,
  });

  Map<String, dynamic> toJson() => {
        'QRCodeID': qrCodeID,
        'ReservationID': reservationID,
        'Code': code,
        'PINCode': pinCode,
      };

  static QRCode fromJson(Map<String, dynamic> json) => QRCode(
        qrCodeID: json['QRCodeID'],
        reservationID: json['ReservationID'],
        code: json['Code'],
        pinCode: json['PINCode'],
      );
}
