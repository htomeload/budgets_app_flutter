import 'package:budget_app_starting/components.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginViewMobile extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double deviceHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: deviceHeight / 5.5),
              Image.asset(
                "logo.png",
                fit: BoxFit.contain,
                width: 210.0,
              ),
              SizedBox(
                height: 30.0,
              ),
              EmailAndPasswordFields(),
              SizedBox(
                height: 30.0,
              ),
              RegisterAndLogin(),
              SizedBox(
                height: 30.0,
              ),
              // Google sign-in button
              GoogleSignInButton()
            ],
          ),
        ),
      ),
    );
  }
}
