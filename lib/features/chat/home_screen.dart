import 'package:chat_bot_demo/features/authentication/bloc/authentication_bloc.dart';
import 'package:chat_bot_demo/utils/constants.dart';
import 'package:chat_bot_demo/utils/custom_colors.dart';
import 'package:chat_bot_demo/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  late final future;

  @override
  void initState() {
    super.initState();

    future = Future.delayed(
      const Duration(milliseconds: 0),
      () async {
        final OwnUser res = await setUpStreamChat();

        client = getIt.get<StreamChatClient>();
        channel = getIt.get<Channel>();

        await channel.addMembers([
          'demo-chat-bot',
          'demo-user',
        ]);
        final QueryMembersResponse members = await channel.queryMembers(
          filter: Filter.equal(
            'id',
            'demo-chat-bot',
          ),
        );

        await channel.sendMessage(
          Message(
            text: 'Message from ADMIN',
            extraData: const {
              "sentByBot": true,
            },
          ),
        );

        return res;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.25,
                    ),
                    const Icon(
                      Icons.warning_amber,
                      size: 80,
                      color: CustomColors.green,
                    ),
                    const Text(
                      'Oopsie...',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Text(
                      'Something went wrong:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
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
    );
  }

  Widget _messageBuilder(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
    StreamMessageWidget defaultMessageWidget,
  ) {
    final Message message = details.message;
    final bool isBotMessage = details.message.extraData['sentByBot'] == true;
    final TextAlign textAlign = isBotMessage ? TextAlign.left : TextAlign.right;
    final Color? bgColor = isBotMessage ? Colors.grey[200] : Colors.teal[700];

    return Row(
      mainAxisAlignment:
          isBotMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: isBotMessage
                  ? const Radius.circular(15)
                  : const Radius.circular(0),
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15),
            ),
          ),
          child: Text(
            message.text!,
            style: TextStyle(
              color: isBotMessage ? Colors.black : Colors.white,
            ),
            textAlign: textAlign,
          ),
        ),
      ],
    );
    ;
  }
}
