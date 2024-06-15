import 'dart:convert';

import 'package:chat_bot_demo/features/authentication/bloc/authentication_bloc.dart';
import 'package:chat_bot_demo/models/message_option.dart';
import 'package:chat_bot_demo/repositories/authentication_repository.dart';
import 'package:chat_bot_demo/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart' as log;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final log.Logger logger = log.Logger(
  printer: log.PrettyPrinter(
    methodCount: 20,
    errorMethodCount: 15,
  ),
);

final GetIt getIt = GetIt.instance;

Future<void> setUpGetIt({
  bool usedForTesting = false,
}) async {
  // Allow stream chat reassignment.
  // Used when user logs out and makes a new account or
  // logs in with another account
  getIt.allowReassignment = true;

  getIt.registerLazySingleton<IAuthenticationRepository>(
    () => IAuthenticationRepository(),
  );

  if (!usedForTesting) {
    getIt.registerSingleton<AuthenticationBloc>(
      AuthenticationBloc(
        auth: getIt.get<IAuthenticationRepository>(),
      ),
    );
  }
}

Future<OwnUser> setUpStreamChat() async {
  // Set up the chat client using the API kEY
  final StreamChatClient client = StreamChatClient(
    dotenv.env['STREAM_APP_ID']!,
    logLevel: Level.INFO,
  );

  final OwnUser res = await client.connectUser(
    User(id: 'demo-user'),
    dotenv.env['DEMO_USER_TOKEN']!,
  );

  final Channel channel = client.channel(
    'messaging',
    id: getIt.get<AuthenticationBloc>().state.user!.id,
  );

  getIt.registerSingleton<StreamChatClient>(client);
  getIt.registerSingleton<Channel>(channel);

  // Listen to messages
  await channel.watch();

  return res;
}

Future<void> sendChannelMessage({
  required String message,
  bool? sentByBot,
  List<MessageOption>? messageOptions,
}) async {
  try {
    final Channel channel = getIt.get<Channel>();

    await channel.sendMessage(
      Message(
        type: 'message',
        text: message,
        extraData: sentByBot == true
            ? {
                'sentByBot': true,
                'messageOptions': json.encode(messageOptions!
                    .map(
                      (e) => e.toJSON(),
                    )
                    .toList()),
              }
            : {},
      ),
    );
  } catch (e, stackTrace) {
    logger.e(
      'Failed to send ${sentByBot == true ? 'BOT' : 'NORMAL'} message: \n'
      '$message \n',
      stackTrace: stackTrace,
    );

    Fluttertoast.showToast(
      msg: 'Failed to send ${sentByBot == true ? 'BOT' : 'NORMAL'} message: \n'
          '$message \n',
      gravity: ToastGravity.BOTTOM,
    );
  }
}

InputDecoration defaultFormFieldStyle({required String label}) {
  return InputDecoration(
    border: InputBorder.none,
    filled: true,
    fillColor: CustomColors.lightGreen,
    labelText: label,
    labelStyle: const TextStyle(
      color: CustomColors.lightGray,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
  );
}

class CustomSnackBar {
  const CustomSnackBar();

  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
    int durationSec = 2,
  }) {
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        padding: EdgeInsets.zero,
        backgroundColor: isError ? Colors.red : CustomColors.green,
        content: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: Center(
            child: Text(
              message.toUpperCase(),
              style: const TextStyle(
                color: CustomColors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        duration: Duration(seconds: durationSec),
      ),
    );
  }
}
