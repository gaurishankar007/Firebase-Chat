import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat/src/core/constant.dart';
import 'package:firebase_chat/src/data/remote/models/message_model.dart';
import 'package:firebase_chat/src/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum MessageSide {
  right,
  left,
}

Widget messageContent({
  required MessageModel messageModel,
  required BuildContext context,
  required MessageSide side,
}) {
  Color primary = Theme.of(context).colorScheme.primary;
  Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;

  return Row(
    mainAxisAlignment: side == MessageSide.right
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
    children: [
      if (messageModel.type == MessageType.text)
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          constraints: BoxConstraints(maxWidth: sWidth(context) * .7),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primary.withOpacity(.5),
                primary,
                primaryContainer,
                primaryContainer.withOpacity(.5),
              ],
              transform: GradientRotation(90),
            ),
            borderRadius: BorderRadius.circular(cBorderRadius),
          ),
          child: Text(
            messageModel.content,
            style: mediumText.copyWith(color: Colors.white),
          ),
        )
      else
        GestureDetector(
          onTap: () {},
          child: Container(
            constraints:
                BoxConstraints(maxWidth: sWidth(context) * .7, maxHeight: 200),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(cBorderRadius),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: messageModel.content,
                placeholder: (context, url) => Container(
                  height: sWidth(context) * .4,
                  width: sWidth(context) * .4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primary.withOpacity(.5),
                        primary,
                        primaryContainer,
                        primaryContainer.withOpacity(.5),
                      ],
                      transform: GradientRotation(90),
                    ),
                    borderRadius: BorderRadius.circular(cBorderRadius),
                  ),
                  child: SpinKitCircle(
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.bug_report_rounded,
                  size: iconSize,
                  color: primary,
                ),
              ),
            ),
          ),
        )
    ],
  );
}
