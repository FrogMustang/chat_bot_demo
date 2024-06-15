import 'package:chat_bot_demo/features/authentication/bloc/authentication_bloc.dart';
import 'package:chat_bot_demo/routing/app_routes_constants.dart';
import 'package:chat_bot_demo/utils/constants.dart';
import 'package:chat_bot_demo/utils/custom_colors.dart';
import 'package:chat_bot_demo/utils/custom_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              leading: Row(
                children: [
                  const SizedBox(
                    width: Constants.kHorScreenPadding,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      CustomIcons.carretLeft,
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<AuthenticationBloc>().add(
                              const AuthenticationLoggedOut(),
                            );

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          kSignInScreen,
                          (_) => false,
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
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.kHorScreenPadding,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 40),
                              Image.asset(
                                CustomIcons.profilePicture,
                                height: 145,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 20),

                              // USERNAME
                              Text(
                                state.user!.email,
                                style: const TextStyle(
                                  fontFamily: 'Ubuntu',
                                  fontSize: 24,
                                  color: CustomColors.dark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              // DETAILS
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // LOCATION
                                    const Text(
                                      'New York',
                                      style: TextStyle(
                                        color: CustomColors.gray,
                                        fontSize: 16,
                                      ),
                                    ),

                                    // dot
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      height: 5,
                                      width: 5,
                                      color: const Color.fromRGBO(
                                        181,
                                        195,
                                        199,
                                        1,
                                      ),
                                    ),

                                    // ID
                                    Flexible(
                                      child: Text(
                                        'ID: ${state.user!.id}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: CustomColors.gray,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                        Spacer(),

                        // BOTTOM INFO
                        Container(
                          color: CustomColors.dark,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.kHorScreenPadding,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 40),
                              const ProfileInfoBanner(
                                icon: CustomIcons.phone,
                                title: 'Phone number',
                                subtitle: '+3788888888',
                              ),
                              const SizedBox(height: 16),
                              ProfileInfoBanner(
                                icon: CustomIcons.email,
                                title: 'Email',
                                subtitle: state.user!.email,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileInfoBanner extends StatelessWidget {
  const ProfileInfoBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(
        horizontal: 27,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColors.dutchSummerSky,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          // ICON
          SvgPicture.asset(
            icon,
            width: 18,
          ),
          const SizedBox(width: 15),

          // DIVIDER
          const VerticalDivider(
            color: CustomColors.dutchSummerSky,
            thickness: 0.5,
          ),

          const SizedBox(width: 15),

          // TITLE AND SUBTITLE
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.gray,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      color: CustomColors.dutchSummerSky,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
