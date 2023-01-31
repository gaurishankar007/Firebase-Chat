import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/constant.dart';

class MessageScreen {
  MessageScreen._();
  static final MessageScreen _message = MessageScreen._();
  factory MessageScreen.message() => _message;

  final List<MessageData> _messageData = [];
  MessageController? _messageController;

  void show({
    required BuildContext context,
    required String message,
    MessageType type = MessageType.normal,
  }) async {
    _messageData.add(MessageData(
      context: context,
      message: message,
      type: type,
    ));

    if (_messageController != null) return;

    while (_messageData.isNotEmpty) {
      _messageController = _showMessage(
        context: _messageData[0].context,
        message: _messageData[0].message,
        type: _messageData[0].type,
      );
      await Future.delayed(Duration(seconds: 3));
      _hide();
      _messageData.removeAt(0);
      if (_messageData.isNotEmpty) {
        await Future.delayed(Duration(milliseconds: 500));
      }
    }
    _messageController = null;
  }

  _hide() {
    if (_messageController == null) return;
    _messageController!.close();
  }

  MessageController _showMessage({
    required BuildContext context,
    required String message,
    required MessageType type,
  }) {
    Color onSurface = Theme.of(context).colorScheme.onSurface;
    final state = Overlay.of(context);

    String messageType = "Message";
    IconData iconData = Icons.email_rounded;
    Color messageColor = onSurface;

    if (type == MessageType.success) {
      messageType = "Success";
      iconData = Icons.message;
      messageColor = Colors.green;
    } else if (type == MessageType.warning) {
      messageType = "Warning";
      iconData = Icons.warning_rounded;
      messageColor = Colors.orange;
    } else if (type == MessageType.error) {
      messageType = "Error";
      iconData = Icons.error_rounded;
      messageColor = Colors.red;
    }

    final overlay = _data(
      context: context,
      widgets: [
        Row(
          children: [
            Icon(
              iconData,
              color: messageColor,
              size: iconSize + 5,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              messageType,
              style: veryLargeText.copyWith(
                color: messageColor,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: sWidth(context) * .8,
            minWidth: sWidth(context) * .5,
          ),
          child: Text(
            message,
            textAlign: TextAlign.start,
            style: mediumText.copyWith(
              color: onSurface,
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                _messageController!.close();
                _messageController = null;
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    bBorderRadius,
                  ),
                ),
              ),
              child: Text("Ok"),
            ),
          ],
        ),
      ],
    );

    state.insert(overlay);

    return MessageController(
      close: () {
        overlay.remove();
        return true;
      },
    );
  }

  MessageController showLoading({
    required BuildContext context,
    String message = "Please Wait.....",
  }) {
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color onSurface = Theme.of(context).colorScheme.onSurface;
    final state = Overlay.of(context);

    final overlay = _data(
      context: context,
      widgets: [
        SizedBox(
          width: 50,
          child: SpinKitCircle(
            color: primaryContainer,
            size: iconSize * 2 + 10,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          message,
          textAlign: TextAlign.start,
          style: mediumText.copyWith(
            color: onSurface,
          ),
        ),
      ],
    );

    state.insert(overlay);

    return MessageController(
      close: () {
        overlay.remove();
        return true;
      },
    );
  }
}

OverlayEntry _data({
  required BuildContext context,
  required List<Widget> widgets,
}) {
  Color surface = Theme.of(context).colorScheme.surface;
  Color onSurface = Theme.of(context).colorScheme.onSurface;
  final renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;

  return OverlayEntry(
    builder: (context) {
      return Material(
        color: onSurface.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: size.height * .8,
              maxWidth: size.width * .8,
              minWidth: size.width * .5,
            ),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(bBorderRadius),
            ),
            padding: EdgeInsets.only(
              right: 20,
              left: 20,
              bottom: 10,
              top: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widgets,
            ),
          ),
        ),
      );
    },
  );
}

typedef CloseMessageScreen = bool Function();

class MessageController {
  final CloseMessageScreen close;

  const MessageController({
    required this.close,
  });
}

enum MessageType {
  normal,
  success,
  error,
  warning,
}

class MessageData {
  BuildContext context;
  String message;
  MessageType type;

  MessageData({
    required this.context,
    required this.message,
    required this.type,
  });
}
