import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/src/data/argument/chat_message_arg.dart';
import 'package:firebase_chat/src/data/remote/models/message_model.dart';
import 'package:firebase_chat/src/domain/entities/message_entity.dart';
import 'package:firebase_chat/src/presentation/blocs/chatMessage/chat_message_bloc.dart';
import 'package:firebase_chat/src/presentation/widgets/page_parts/message_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

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

    return BlocProvider(
      create: (context) => ChatMessageBloc(context: context)
        ..add(MessageLoadedEvent(chatId: data.chatId)),
      child: Scaffold(
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
        body: BlocBuilder<ChatMessageBloc, ChatMessageState>(
          builder: (context, state) {
            if (state is MessageLoadedState) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sWidth(context) * .04,
                      vertical: 10,
                    ),
                    child: StreamBuilder(
                      stream: state.chatStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<MessageModel> messageModels = snapshot.data!.docs
                              .map((doc) => doc.data())
                              .toList();

                          if (messageModels.isEmpty) {
                            return Column(
                              children: [
                                Text("Say 'hi' to ${data.toName}."),
                              ],
                            );
                          }

                          return ListView.separated(
                            reverse: true,
                            controller: state.scrollController,
                            padding: EdgeInsets.only(bottom: 55),
                            itemCount: messageModels.length,
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemBuilder: (context, index) {
                              if (messageModels[index].uId == data.toId) {
                                return messageContent(
                                  messageModel: messageModels[index],
                                  context: context,
                                  side: MessageSide.right,
                                );
                              } else {
                                return messageContent(
                                  messageModel: messageModels[index],
                                  context: context,
                                  side: MessageSide.left,
                                );
                              }
                            },
                          );
                        }

                        return Column();
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: sWidth(context) * .04,
                      vertical: 10,
                    ),
                    height: 50,
                    color: surface,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => BlocProvider.of<ChatMessageBloc>(context)
                              .add(SendImageEvent(
                            uId: data.toId,
                            imageSource: ImageSource.camera,
                            chatId: data.chatId,
                          )),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: primary,
                            size: iconSize + 5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => BlocProvider.of<ChatMessageBloc>(context)
                              .add(SendImageEvent(
                            uId: data.toId,
                            imageSource: ImageSource.gallery,
                            chatId: data.chatId,
                          )),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.photo_rounded,
                              color: primary,
                              size: iconSize + 5,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                            height: 30,
                            margin: EdgeInsets.only(
                              left: 5,
                              right: 15,
                            ),
                            child: TextFormField(
                              controller: state.textController,
                              keyboardType: TextInputType.multiline,
                              focusNode: state.focusNode,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                filled: true,
                                fillColor: onSurface.withOpacity(.05),
                                hintText: 'Message',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(cBorderRadius),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(cBorderRadius),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (state.textController.text.isEmpty) return;

                            BlocProvider.of<ChatMessageBloc>(context).add(
                              SendMessageEvent(
                                messageModel: MessageModel(
                                  uId: data.toId,
                                  content: state.textController.text,
                                  type: MessageType.text,
                                  createdAt: Timestamp.now(),
                                ),
                                chatId: data.chatId,
                              ),
                            );
                          },
                          child: Icon(
                            Icons.send_rounded,
                            color: primary,
                            size: iconSize + 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: SpinKitCircle(
                color: primary,
                size: iconSize * 2,
              ),
            );
          },
        ),
      ),
    );
  }
}
