import 'package:flutter/material.dart';

import '../../data/remote/repositories/auth_repo_impl.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;

    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primary.withOpacity(.5),
                primary,
                primaryContainer.withOpacity(.5),
                primaryContainer,
              ],
              transform: GradientRotation(90),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
