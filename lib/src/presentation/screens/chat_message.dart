import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat/src/data/argument/chat_message_arg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/constant.dart';

class ChatMessage extends StatelessWidget {
  final ChatMessageArg data;
  const ChatMessage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
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
        leadingWidth: 35,
        title: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                width: 35,
                fit: BoxFit.cover,
                imageUrl: data.toAvatar,
                placeholder: (context, url) => SpinKitCircle(
                  color: primary,
                  size: iconSize,
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(
                    Icons.bug_report_rounded,
                    size: iconSize,
                    color: primary,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              data.toName,
              style: largeText,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: sWidth(context) * .04,
          vertical: 10,
        ),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
