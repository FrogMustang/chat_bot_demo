import 'package:chat_bot_demo/features/authentication/bloc/authentication_bloc.dart';
import 'package:chat_bot_demo/firebase_options.dart';
import 'package:chat_bot_demo/routing/app_routes.dart';
import 'package:chat_bot_demo/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> startApplication() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");
  await setUpGetIt();
  // await setUpStreamChat();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt.get<AuthenticationBloc>(),
        ),
      ],
      child: const MaterialApp(
        title: 'Profile Demo App',
        onGenerateRoute: AppRoutes.routes,
      ),
    ),
  );
}
