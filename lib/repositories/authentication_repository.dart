import 'dart:async';

import 'package:chat_bot_demo/models/app_user.dart';
import 'package:chat_bot_demo/repositories/repositories.dart';
import 'package:chat_bot_demo/utils/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IAuthenticationRepository extends AuthenticationRepository {
  @override
  Stream<AppUser?> get user {
    return FirebaseAuth.instance.authStateChanges().map((firebaseUser) {
      return firebaseUser?.toUser;
    });
  }

  @override
  Future<Either<String, bool>> login({
    required String username,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      return const Right(true);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to log in: $e',
        stackTrace: stackTrace,
      );

      return const Left('Your username and/or password might be wrong. '
          'Please try again.');
    }
  }

  @override
  Future<Either<String, bool>> signUp({
    required String username,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.w('The password provided is too weak');

        return const Left('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        logger.e('The account already exists for that email');

        return const Left('The account already exists for that email');
      }

      logger.e(
        'Failed to create account ${e.message}',
        stackTrace: e.stackTrace,
      );

      return Left('Failed to create account ${e.message}');
    } catch (e, stackTrace) {
      logger.e(
        'Failed to create account: $e',
        stackTrace: stackTrace,
      );

      return Left('Failed to create account: $e');
    }
  }

  @override
  Future<Either<String, bool>> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      return const Right(true);
    } catch (e, stackTrace) {
      logger.e(
        'Failed to log out: $e',
        stackTrace: stackTrace,
      );

      return Left('FAiled to log out: $e');
    }
  }
}

extension on User {
  AppUser get toUser {
    return AppUser(
      id: uid,
      email: email ?? 'no@email.com',
    );
  }
}
