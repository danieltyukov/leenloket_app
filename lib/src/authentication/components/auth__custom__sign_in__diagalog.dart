import 'package:Leenloket/src/authentication/auth__register_view.dart';
import 'package:Leenloket/src/authentication/components/auth__sign_in__form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<Object?> showCustomDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Login",
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (__, animation, _, child) {
      Tween<Offset> tween;
      tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 620,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  const Text("Sign in",
                      style: TextStyle(fontSize: 34, fontFamily: "Poppins")),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 32),
                    child: Text(
                      "Sign in to your account to start lending items.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SignInForm(),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AuthRegisterView.routeName);
                    },
                    child: const Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const Positioned(
                bottom: -52,
                left: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    CupertinoIcons.xmark,
                    size: 24,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}
