import 'package:flutter/material.dart';

import '../../../core/constant.dart';
import '../../../data/remote/repositories/auth_repo_impl.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            top: sHeight(context) * .05,
            bottom: sHeight(context) * .35,
          ),
          width: sWidth(context),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/ic_launcher.png",
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "Let's Chat",
                      style: largeText,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Sing in with social networks",
                      style: mediumText,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => AuthRepo().googleSignIn(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: onPrimary,
                    ),
                    child: Text("Continue with google"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
