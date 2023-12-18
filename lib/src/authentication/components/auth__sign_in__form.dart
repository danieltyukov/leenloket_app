import 'package:Leenloket/src/home/admin__home_view.dart';
import 'package:Leenloket/src/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
  });

  Future<void> _loginUser(
      BuildContext context, String email, String password) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate based on the role
      if (userCredential.user != null) {
        // Retrieve the role from the database
        final uid = userCredential.user!.uid;
        final ref = FirebaseDatabase.instance.ref("Users/$uid");
        final snapshot = await ref.get();

        if (snapshot.exists && snapshot.value is Map) {
          final data = Map<String, dynamic>.from(snapshot.value as Map);
          final user = UserModel.User.fromJson(data);

          if (user.roleID == "r1") {
            Navigator.of(context).pushReplacementNamed(AdminHomeView.routeName);
          } else if (user.roleID == "r2") {
            Navigator.of(context).pushReplacementNamed(HomeView.routeName);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle login error
      print("Login failed: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Form(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Email",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 12),
        ),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(CupertinoIcons.mail),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text("Password",
            textAlign: TextAlign.start, style: TextStyle(fontSize: 12)),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(CupertinoIcons.lock),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () async {
            await _loginUser(
                context, emailController.text, passwordController.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            minimumSize: const Size(double.infinity, 56),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(25))),
          ),
          icon: const Icon(
            CupertinoIcons.arrow_right,
            color: Colors.white,
          ),
          label: const Text(
            "Sign in",
            style: TextStyle(color: Colors.white),
          ),
        )
      ]),
    );
  }
}
