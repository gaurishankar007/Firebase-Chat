import 'package:flutter/material.dart';

import '../../data/remote/repositories/auth_repo_impl.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("HomePage"),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => AuthRepo().signOut(context: context),
            child: Text("Sign Out"),
          ),
        ],
      ),
    );
  }
}
