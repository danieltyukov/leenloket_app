import 'dart:io';

import 'package:Leenloket/src/home/admin__home_view.dart';
import 'package:Leenloket/src/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;
import 'package:rive/rive.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isShowLoading = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");

    artboard.addController(controller!);

    return controller;
  }

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
          }

          if (user.roleID == "r2") {
            Navigator.of(context).pushReplacementNamed(HomeView.routeName);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      error.fire();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isShowLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Email",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 12),
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (email) {},
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (password) {},
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
                setState(() {
                  isShowLoading = true;
                });
                Future.delayed(const Duration(seconds: 1), () {
                  if (_formKey.currentState!.validate()) {
                    //Everything is fine, login the user.
                    _loginUser(
                        context, emailController.text, passwordController.text);
                  } else {
                    //Something is wrong, show error message.
                    error.fire();
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        isShowLoading = false;
                      });
                    });
                  }
                });
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
        ),
        isShowLoading
            ? Positioned.fill(
                child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: RiveAnimation.asset("assets/rive/checkerror.riv",
                        onInit: (artboard) {
                      StateMachineController controller =
                          getRiveController(artboard);
                      check = controller.findSMI("Check") as SMITrigger;
                      error = controller.findSMI("Error") as SMITrigger;
                      reset = controller.findSMI("Reset") as SMITrigger;
                    }),
                  ),
                  const Spacer(flex: 2),
                ],
              ))
            : const SizedBox()
      ],
    );
  }
}
