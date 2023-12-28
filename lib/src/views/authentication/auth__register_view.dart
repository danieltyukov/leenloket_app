import 'package:Leenloket/src/views/authentication/auth__onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;

class AuthRegisterView extends StatelessWidget {
  const AuthRegisterView({super.key});

  static const routeName = '/register';

  Future<void> _registerUser(BuildContext context, String email,
      String password, String name, String phone, String address) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final passwordHash = sha256.convert(utf8.encode(password)).toString();

        final user = UserModel.User(
          name: name,
          email: email,
          phone: phone,
          address: address,
          roleID: "r2",
          password: passwordHash,
        );

        final DatabaseReference ref =
            FirebaseDatabase.instance.ref("Users/${firebaseUser.uid}");
        await ref.set(user.toJson());

        Navigator.of(context).pushReplacementNamed(OnboardingView.routeName);
      }
    } on FirebaseAuthException catch (e) {
      // Handle login error
      print("Register failed: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Register failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

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
                'Register',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
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
                  await _registerUser(
                      context,
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                      phoneController.text,
                      addressController.text);
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(OnboardingView.routeName);
                },
                child: const Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
