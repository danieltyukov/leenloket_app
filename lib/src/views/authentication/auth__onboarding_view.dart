import 'dart:ui';

import 'package:Leenloket/src/views/authentication/auth__register_view.dart';
import 'package:Leenloket/src/views/authentication/components/auth__custom__sign_in__diagalog.dart';
import 'package:Leenloket/src/views/authentication/components/auth__sign_in__form.dart';
import 'package:Leenloket/src/views/user/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  static const routeName = '/onboarding';

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  bool isSignInDialogOpen = false;
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
          AnimatedPositioned(
            top: isSignInDialogOpen ? -50 : 0,
            duration: const Duration(milliseconds: 240),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SafeArea(
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
                            Future.delayed(const Duration(milliseconds: 800),
                                () {
                              setState(() {
                                isSignInDialogOpen = true;
                              });
                              showCustomDialog(context, onClosed: (_) {
                                setState(() {
                                  isSignInDialogOpen = false;
                                });
                              });
                            });
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
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "Use Leenloket",
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
                    ))),
          )
        ],
      ),
    );
  }
}
