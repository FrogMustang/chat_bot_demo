import 'package:chat_bot_demo/features/chat/message_options/message_ids.dart';
import 'package:chat_bot_demo/models/message_option.dart';
import 'package:chat_bot_demo/routing/app_routes_constants.dart';
import 'package:chat_bot_demo/utils/custom_icons.dart';
import 'package:chat_bot_demo/utils/utils.dart';
import 'package:flutter/material.dart';

List<MessageOption> getMessageOptions({required String id}) {
  return switch (id) {
    MessageIds.yeahStartConversation => [
        MessageOption(
          id: MessageIds.checkProfile,
          optionText: "Check profile",
          svgIcon: CustomIcons.redirect,
        ),
        MessageOption(
          id: MessageIds.seeCoolTrick,
          optionText: "Show me the cool trick",
          svgIcon: CustomIcons.reply,
        ),
      ],
    MessageIds.seeVideoAsWell => [
        MessageOption(
          id: MessageIds.showMeTheVideo,
          optionText: "Show me the VIDEO!!!",
          svgIcon: CustomIcons.reply,
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
        // SEND USER REPLY
        await sendChannelMessage(message: mo.optionText);

        // SEND BOT REPLY
        await sendChannelMessage(
          message: "Wanna check your profile or see a cool trick?",
          sentByBot: true,
          messageOptions: [
            MessageOption(
              id: MessageIds.checkProfile,
              optionText: 'Check your profile',
              svgIcon: CustomIcons.redirect,
            ),
            MessageOption(
              id: MessageIds.seeCoolTrick,
              optionText:
                  "Show me the trick. Show me. Show me 😁😁I'm so excited",
              svgIcon: CustomIcons.reply,
            ),
          ],
        );
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
    MessageIds.checkProfile => () {
        Navigator.pushNamed(context, kProfile);
      },
    MessageIds.seeCoolTrick => () async {
        // SEND USER REPLY
        await sendChannelMessage(message: mo.optionText);

        // SEND BOT REPLY
        await sendChannelMessage(
          message: "Check out this cool photo attached below",
          sentByBot: true,
          attachmentLink: 'https://picsum.photos/500',
        );

        // SEND VIDEO LINK MESSAGE HOOK
        await Future.delayed(
          const Duration(seconds: 3),
          () async {
            await sendChannelMessage(
              message: "Wanna see a video as well?",
              sentByBot: true,
              messageOptions: [
                MessageOption(
                  id: MessageIds.seeVideoAsWell,
                  optionText: "Show me the video!",
                  svgIcon: CustomIcons.reply,
                ),
              ],
            );
          },
        );
      },
    MessageIds.seeVideoAsWell => () async {
        // SEND BOT REPLY
        await sendChannelMessage(
          message: "Oke, here it is:",
          sentByBot: true,
          attachmentLink: 'https://youtu.be/Atp6ELX8ay4',
        );
      },
    _ => throw UnimplementedError(
        'Please provide a callback for this message ID: ${mo.id}',
      ),
  };
}
