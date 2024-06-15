import 'package:chat_bot_demo/features/chat/message_options/message_ids.dart';
import 'package:chat_bot_demo/models/message_option.dart';
import 'package:chat_bot_demo/routing/app_routes_constants.dart';
import 'package:chat_bot_demo/utils/custom_icons.dart';
import 'package:chat_bot_demo/utils/utils.dart';
import 'package:flutter/material.dart';

List<MessageOption> getMessageOptions({required MessageOption mo}) {
  return switch (mo.id) {
    MessageIds.yeahStartConversation => [
        MessageOption(
          id: MessageIds.checkProfile,
          nextMessageId: null,
          optionText: "Check profile",
          svgIcon: CustomIcons.redirect,
        ),
      ],
    _ => [],
  };
}

Function getMessageOptionCallback({
  required BuildContext context,
  required MessageOption mo,
}) {
  return switch (mo.id) {
    MessageIds.yeahStartConversation => () async {
        await sendChannelMessageWithOptions(
          mo: mo,
          message: 'Wanna check your profile?',
        );
      },
    MessageIds.checkProfile => () {
        Navigator.pushNamed(context, kProfile);
      },
    MessageIds.noTalkLater => () async {
        // SEND USER REPLY
        await sendChannelMessage(message: mo.optionText);

        // SEND BOT REPLY
        await sendChannelMessage(
          message: "Okay, I'll text you back later",
          sentByBot: true,
        );
      },
    _ => throw UnimplementedError(
        'Please provide a callback for this message ID: ${mo.id}',
      ),
  };
}

Future<void> sendChannelMessageWithOptions({
  required MessageOption mo,
  required String message,
}) async {
  final List<MessageOption> messageOptions = getMessageOptions(mo: mo);

  final MessageOption nextMessage = messageOptions.firstWhere(
    (e) => e.id == mo.nextMessageId,
  );

  // SEND USER REPLY
  await sendChannelMessage(message: mo.optionText);

  // SEND NEXT BOT MESSAGE
  await sendChannelMessage(
    message: message,
    sentByBot: true,
    messageOptions: messageOptions,
  );
}
