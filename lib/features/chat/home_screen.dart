import 'package:chat_bot_demo/features/authentication/bloc/authentication_bloc.dart';
import 'package:chat_bot_demo/utils/constants.dart';
import 'package:chat_bot_demo/utils/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.kHorScreenPadding,
                ),
                child: state.user == null
                    ? const CupertinoActivityIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 22),

                          // USERNAME
                          Text(
                            state.user!.email,
                            style: const TextStyle(
                              fontSize: 24,
                              color: CustomColors.dark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'ID: ${state.user!.id}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CustomColors.gray,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
