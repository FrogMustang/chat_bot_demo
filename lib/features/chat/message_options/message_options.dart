import 'package:chat_bot_demo/features/chat/message_options/message_ids.dart';
import 'package:chat_bot_demo/models/message_option.dart';
import 'package:chat_bot_demo/utils/utils.dart';

List<MessageOption> getMessageOptions({required MessageOption mo}) {
  return switch (mo.id) {
    MessageIds.firstMessageOption1 => [
        MessageOption(
          id: MessageIds.checkProfile,
          nextMessageId: null,
          text: "Check profile",
        ),
      ],
    _ => [],
  };
}

Function getMessageOptionCallback({
  required MessageOption mo,
}) {
  return switch (mo.id) {
    MessageIds.firstMessageOption1 => () async {
        final List<MessageOption> messageOptions = getMessageOptions(mo: mo);
        print("NEXT MESSAGE: ${mo.nextMessageId}");

        final MessageOption nextMessage = messageOptions.firstWhere(
          (e) => e.id == mo.nextMessageId,
        );

        // SEND USER REPLY
        await sendChannelMessage(message: mo.text);

        // SEND NEXT BOT MESSAGE
        await sendChannelMessage(
          message: nextMessage.text,
          sentByBot: true,
          messageOptions: messageOptions,
        );
      },
    _ => throw UnimplementedError(
        'Please provide a callback for this message ID: ${mo.id}',
      ),
  };
}
