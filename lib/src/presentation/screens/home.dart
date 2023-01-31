import 'package:firebase_chat/src/data/remote/repositories/firebase_repo_impl.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("HomePage"),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => FirebaseAuthRepoImpl().signOut(context),
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
