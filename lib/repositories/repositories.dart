import 'package:chat_bot_demo/models/app_user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticationRepository {
  Stream<AppUser?> get user;

  Future<Either<String, bool>> login({
    required String username,
    required String password,
  });

  Future<Either<String, bool>> signUp({
    required String username,
    required String password,
  });

  Future<Either<String, bool>> logout();
}
