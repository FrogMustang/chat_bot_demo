import 'dart:convert';

import 'package:chat_bot_demo/features/authentication/bloc/authentication_bloc.dart';
import 'package:chat_bot_demo/features/chat/message_options/message_ids.dart';
import 'package:chat_bot_demo/models/message_option.dart';
import 'package:chat_bot_demo/utils/constants.dart';
import 'package:chat_bot_demo/utils/custom_colors.dart';
import 'package:chat_bot_demo/utils/custom_icons.dart';
import 'package:chat_bot_demo/utils/utils.dart';
import 'package:chat_bot_demo/widgets/error_screen.dart';
import 'package:chat_bot_demo/widgets/message_option_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Instance of [StreamChatClient] we created earlier. This contains information about
  /// our application and connection state.
  // final StreamChatClient client = getIt.get<StreamChatClient>();
  late final StreamChatClient client;

  /// The channel we'd like to observe and participate.
  // final Channel channel = getIt.get<Channel>();
  late final Channel channel;

  late final Future<OwnUser?> future;

  @override
  void initState() {
    super.initState();

    future = Future.delayed(
      const Duration(milliseconds: 0),
      () async {
        try {
          final OwnUser res = await setUpStreamChat();

          client = getIt.get<StreamChatClient>();
          channel = getIt.get<Channel>();

          await channel.addMembers(
            [
              'demo-chat-bot',
              'demo-user',
            ],
          );

          await sendChannelMessage(
            message: 'Are you ready to start the conversation?',
            sentByBot: true,
            messageOptions: [
              MessageOption(
                id: MessageIds.yeahStartConversation,
                nextMessageId: MessageIds.checkProfile,
                optionText: "Yeah! :)",
                svgIcon: CustomIcons.reply,
              ),
              MessageOption(
                id: MessageIds.noTalkLater,
                nextMessageId: MessageIds.botComeBackLater,
                optionText: "No, let's talk later",
                svgIcon: CustomIcons.reply,
              ),
            ],
          );

          return res;
        } catch (e, stackTrace) {
          logger.e(
            "Failed to set up chat: \n"
            "$e",
            stackTrace: stackTrace,
          );

          Fluttertoast.showToast(
            msg: 'Failed to set up chat: \n$e',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            timeInSecForIosWeb: 2,
          );

          return null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            logger.e(
              'HOME SCREEN ERROR: ${snapshot.error}',
              stackTrace: snapshot.stackTrace,
            );

            return ErrorScreen(error: snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      actions: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<AuthenticationBloc>().add(
                                      const AuthenticationLoggedOut(),
                                    );
                              },
                              child: const Icon(Icons.logout),
                            ),
                            const SizedBox(
                              width: Constants.kHorScreenPadding,
                            ),
                          ],
                        ),
                      ],
                    ),
                    body: SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      width: MediaQuery.sizeOf(context).width,
                      child: state.user == null
                          ? const CupertinoActivityIndicator()
                          : StreamChat(
                              client: client,
                              child: StreamChannel(
                                channel: channel,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: StreamMessageListView(
                                        messageBuilder: _messageBuilder,
                                      ),
                                    ),
                                    const StreamMessageInput(),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: SpinKitDualRing(
              color: CustomColors.green,
            ),
          );
        },
      ),
    );
  }

  Widget _messageBuilder(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
    StreamMessageWidget defaultMessageWidget,
  ) {
    // messages are reversed (most recent first), so we look for the first one in the list
    final Message lastBotMessage = messages.firstWhere(
        (Message message) => message.extraData['sentByBot'] == true);
    final Message message = details.message;
    final bool isLatestBotMessage = message.id == lastBotMessage.id;

    final bool isBotMessage = message.extraData['sentByBot'] == true;
    final TextAlign textAlign = isBotMessage ? TextAlign.left : TextAlign.right;
    final Color? bgColor = isBotMessage ? Colors.grey[200] : Colors.teal[700];
    List<MessageOption> messageOptions = [];

    if (message.extraData['messageOptions'] != null) {
      final List<dynamic> decoded =
          (json.decode(message.extraData['messageOptions'].toString()))
              as List<dynamic>;

      messageOptions = (decoded).map((data) {
        return MessageOption.fromJson(data);
      }).toList();
    }

    return Row(
      mainAxisAlignment:
          isBotMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: isBotMessage
                  ? const Radius.circular(0)
                  : const Radius.circular(15),
              topRight: isBotMessage
                  ? const Radius.circular(15)
                  : const Radius.circular(0),
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15),
            ),
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // MESSAGE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          message.text!,
                          style: TextStyle(
                            color: isBotMessage ? Colors.black : Colors.white,
                          ),
                          textAlign: textAlign,
                        ),
                      ),
                    ],
                  ),
                ),

                // MESSAGE OPTIONS
                Column(
                  children: [
                    if (messageOptions.isNotEmpty) ...[
                      for (final MessageOption mo in messageOptions) ...[
                        const Divider(color: CustomColors.lightGray),
                        MessageOptionWidget(
                          messageOption: mo,
                          isBotMessage: isBotMessage,
                          isLatestBotMessage: isLatestBotMessage,
                        ),
                      ],
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
