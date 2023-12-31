import 'package:firebase_auth/firebase_auth.dart';

Future<void> firebaseLogout() async {
  FirebaseAuth.instance.signOut();
}

Future<User> getCurrentAuthenticatedFirebaseUser() async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User firebaseUser = auth.currentUser!;

  return firebaseUser;
}
