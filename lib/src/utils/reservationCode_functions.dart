import 'dart:math';
import 'package:firebase_database/firebase_database.dart';

int createReservationCode() {
  Random random = Random();
  int randomNumber = random.nextInt(9999);

  FirebaseDatabase.instance.ref('Codes/$randomNumber').get().then((value) {
    if (value.exists || randomNumber.toString().length != 4) {
      createReservationCode();
    }
  });

  return randomNumber;
}
