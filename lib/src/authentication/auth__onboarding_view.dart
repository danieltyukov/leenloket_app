import 'dart:ui';

import 'package:Leenloket/src/authentication/auth__register_view.dart';
import 'package:Leenloket/src/home/admin__home_view.dart';
import 'package:Leenloket/src/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:Leenloket/src/models/user_model.dart' as UserModel;

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  static const routeName = '/onboarding';

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    super.initState();
    _btnAnimationController = OneShotAnimation('Active', autoplay: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const RiveAnimation.asset(
            'assets/rive/onboarding_screen.riv',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: const SizedBox())),
          SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      const SizedBox(
                        width: 260,
                        child: Column(
                          children: [
                            Text("Lend, use & return",
                                style: TextStyle(
                                    fontSize: 60,
                                    fontFamily: "Poppins",
                                    height: 1.2)),
                            SizedBox(height: 16),
                            Text(
                                "You do not need to buy items anymore for a onetime use. Lend items from the Leenloket and return them when you are done.")
                          ],
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      GestureDetector(
                        onTap: () {
                          _btnAnimationController.isActive = true;
                          showCustomDialog(context);
                        },
                        child: SizedBox(
                            height: 64,
                            width: 260,
                            child: Stack(
                              children: [
                                RiveAnimation.asset(
                                  "assets/rive/leenloket_button.riv",
                                  controllers: [_btnAnimationController],
                                ),
                                const Positioned.fill(
                                    top: 8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.arrow_right),
                                        Text(
                                          "Go to Leenloket",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )),
                              ],
                            )),
                      ),
                      const SizedBox(height: 64),
                    ],
                  )))
        ],
      ),
    );
  }

  Future<Object?> showCustomDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Login",
        pageBuilder: (context, _, __) => Center(
            child: Container(
                height: 620,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
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
                                style: TextStyle(
                                    fontSize: 34, fontFamily: "Poppins")),
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
                    )))));
  }
}

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
