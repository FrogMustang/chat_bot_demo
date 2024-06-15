import 'package:chat_bot_demo/features/authentication/bloc/authentication_bloc.dart';
import 'package:chat_bot_demo/utils/constants.dart';
import 'package:chat_bot_demo/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    this.error,
  });

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              if (error?.isNotEmpty == true) ...{
                const SizedBox(height: 30),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
