import 'package:chat_bot_demo/features/authentication/authentication_screen.dart';
import 'package:chat_bot_demo/features/chat/home_screen.dart';
import 'package:chat_bot_demo/features/authentication/sign_in_screen.dart';
import 'package:chat_bot_demo/features/authentication/sign_up_screen.dart';
import 'package:chat_bot_demo/routing/app_routes_constants.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> routes(RouteSettings settings) {
    switch (settings.name) {
      case kAuthenticate:
        return MaterialPageRoute(
          builder: (_) => const AuthenticationScreen(),
          settings: settings,
        );
      case kSignInScreen:
        return MaterialPageRoute(
          builder: (_) => const SignInScreen(),
          settings: settings,
        );
      case kSignUpScreen:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );
      case kHomeScreen:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const AuthenticationScreen(),
          settings: settings,
        );
    }
  }
}
