import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:leenloket_app/src/home/home_view.dart';
import 'package:leenloket_app/src/home/admin__home_view.dart';
import 'package:leenloket_app/src/authentication/auth__register_view.dart';
import 'package:leenloket_app/src/models/user_model.dart' as UserModel;

class AuthLoginView extends StatelessWidget {
  const AuthLoginView({super.key});

  static const routeName = '/login';

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/citywalk.jpg'),
                width: 128,
              ),
              const SizedBox(height: 32),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await _loginUser(
                      context, emailController.text, passwordController.text);
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AuthRegisterView.routeName);
                },
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
