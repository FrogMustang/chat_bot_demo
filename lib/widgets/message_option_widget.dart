import 'package:chat_bot_demo/features/chat/message_options/message_options.dart';
import 'package:chat_bot_demo/models/message_option.dart';
import 'package:chat_bot_demo/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageOptionWidget extends StatelessWidget {
  const MessageOptionWidget({
    super.key,
    required this.messageOption,
    this.isBotMessage = false,
    required this.isLatestBotMessage,
    this.textColor = CustomColors.green,
  });

  final MessageOption messageOption;
  final bool isBotMessage;
  final bool isLatestBotMessage;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isLatestBotMessage) {
          await getMessageOptionCallback(context: context, mo: messageOption)
              .call();
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// ICON
          if (messageOption.svgIcon?.isNotEmpty == true) ...{
            SvgPicture.asset(
              messageOption.svgIcon!,
              colorFilter: const ColorFilter.mode(
                CustomColors.green,
                BlendMode.srcIn,
              ),
              width: 16,
            ),
          },
          const SizedBox(width: 10),

          // TEXT
          Text(
            messageOption.optionText,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
