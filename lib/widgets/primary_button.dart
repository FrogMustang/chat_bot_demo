import 'package:chat_bot_demo/utils/custom_colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    this.outlinedStyle = false,
    required this.text,
    this.leadingIcon,
    this.textColor = CustomColors.white,
    this.backgroundColor = CustomColors.green,
  });

  final Function? onPressed;
  final bool outlinedStyle;
  final String text;
  final Widget? leadingIcon;
  final Color textColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        height: 60,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: outlinedStyle ? null : backgroundColor,
          border: outlinedStyle
              ? Border.all(
                  color: CustomColors.dutchSummerSky,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...{
              leadingIcon!,
              const SizedBox(width: 5),
            },
            Text(
              text,
              style: TextStyle(
                color: outlinedStyle ? CustomColors.gray : textColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
