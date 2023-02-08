import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_chat/src/core/date_converter.dart';
import 'package:firebase_chat/src/data/argument/chat_message_arg.dart';
import 'package:firebase_chat/src/data/local/local_data.dart';
import 'package:firebase_chat/src/presentation/blocs/chatList/chat_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/constant.dart';

class ChatList extends StatelessWidget {
  final String userId = LocalData.googleUserModel!.accessToken;
  ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).colorScheme.primary;
    Color primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    Color surface = Theme.of(context).colorScheme.surface;
    Color onSurface = Theme.of(context).colorScheme.onSurface;

    return BlocProvider(
      create: (context) => ChatListBloc(),
      child: Scaffold(
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
        body: BlocBuilder<ChatListBloc, ChatListState>(
          builder: (context, state) {
            if (state is ChatListLoadedState) {
              return ListView.separated(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: sWidth(context) * .04,
                  vertical: 10,
                ),
                shrinkWrap: true,
                itemCount: state.chatModels.length,
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(
                    left: sWidth(context) * .13,
                    bottom: 5,
                  ),
                  child: Divider(
                    color: onSurface.withOpacity(.3),
                  ),
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    highlightColor: Colors.transparent,
                    onTap: () {
                      late String toId, toName, toAvatar;

                      if (userId == state.chatModels[index].data()!.toId) {
                        toId = state.chatModels[index].data()!.fromId;
                        toName = state.chatModels[index].data()!.fromName;
                        toAvatar = state.chatModels[index].data()!.fromAvatar;
                      } else {
                        toId = state.chatModels[index].data()!.toId;
                        toName = state.chatModels[index].data()!.toName;
                        toAvatar = state.chatModels[index].data()!.toAvatar;
                      }

                      Navigator.pushNamed(context, "/chatMessage",
                          arguments: ChatMessageArg(
                            chatId: state.chatModels[index].id,
                            toId: toId,
                            toName: toName,
                            toAvatar: toAvatar,
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: surface,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: onSurface.withOpacity(.05),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(2, 2),
                                  )
                                ],
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                  imageUrl: userId ==
                                          state.chatModels[index].data()!.toId
                                      ? state.chatModels[index]
                                          .data()!
                                          .fromAvatar
                                      : state.chatModels[index]
                                          .data()!
                                          .toAvatar,
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
                            ),
                            SizedBox(
                              width: sWidth(context) * .6,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userId ==
                                            state.chatModels[index].data()!.toId
                                        ? state.chatModels[index]
                                            .data()!
                                            .fromName
                                        : state.chatModels[index]
                                            .data()!
                                            .toName,
                                    textAlign: TextAlign.start,
                                    style: largeText.copyWith(
                                      color: onSurface,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (state.chatModels[index]
                                      .data()!
                                      .lastMsg
                                      .isNotEmpty)
                                    Text(
                                      state.chatModels[index].data()!.lastMsg,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: smallBoldText.copyWith(
                                        color: onSurface.withOpacity(.6),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          getTime(state.chatModels[index]
                              .data()!
                              .lastTime
                              .toDate()),
                          textAlign: TextAlign.start,
                          style: smallBoldText.copyWith(
                            color: onSurface.withOpacity(.6),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return Center(
              child: SpinKitCircle(
                color: primary,
                size: iconSize,
              ),
            );
          },
        ),
      ),
    );
  }
}
