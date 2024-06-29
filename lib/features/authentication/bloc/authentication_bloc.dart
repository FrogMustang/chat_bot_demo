import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chat_bot_demo/models/app_user.dart';
import 'package:chat_bot_demo/repositories/repositories.dart';
import 'package:chat_bot_demo/utils/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:quiver/core.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required this.auth,
    this.usedForTesting = false,
  }) : super(const AuthenticationState()) {
    on<AuthenticationUserChanged>(
      _onUserChanged,
      transformer: droppable(),
    );
    on<AuthenticationLoggedIn>(_onLogin);
    on<AuthenticationSignedUp>(_onSignUp);
    on<AuthenticationLoggedOut>(_onLogOut);

    if (!usedForTesting) {
      _userSubscription = auth.user.listen(
        (AppUser? user) {
          logger.i('USER CHANGED: $user');

          add(AuthenticationUserChanged(newUser: user));
        },
      );
    }
  }

  final AuthenticationRepository auth;
  StreamSubscription<AppUser?>? _userSubscription;
  final bool usedForTesting;

  void _onUserChanged(
    AuthenticationUserChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(
      state.copyWith(
        user: Optional.fromNullable(
          event.newUser,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    if (_userSubscription != null) {
      _userSubscription!.cancel();
    }

    return super.close();
  }

  Future<void> _onLogin(
    AuthenticationLoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: FormzStatus.submissionInProgress,
        ),
      );

      final Either<String, bool> res = await auth.login(
        username: event.username,
        password: event.password,
      );

      res.fold(
        (String error) {
          emit(
            state.copyWith(
              status: FormzStatus.submissionFailure,
              error: error,
            ),
          );
        },
        (bool success) {
          emit(
            state.copyWith(
              status: success
                  ? FormzStatus.submissionSuccess
                  : FormzStatus.submissionFailure,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      logger.e('Failed to log in: \n'
          'ERROR: $e \n'
          '$stackTrace');
    }
  }

  Future<void> _onSignUp(
    AuthenticationSignedUp event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: FormzStatus.submissionInProgress,
        ),
      );

      final Either<String, bool> res = await auth.signUp(
        username: event.username,
        password: event.password,
      );

      res.fold(
        (String error) {
          emit(
            state.copyWith(
              status: FormzStatus.submissionFailure,
              error: error,
            ),
          );
        },
        (bool success) {
          emit(
            state.copyWith(
              status: success
                  ? FormzStatus.submissionSuccess
                  : FormzStatus.submissionFailure,
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      logger.e('Failed to create a new account: \n'
          'ERROR: $e \n'
          '$stackTrace');
    }
  }

  Future<void> _onLogOut(
    AuthenticationLoggedOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: FormzStatus.submissionInProgress,
        ),
      );

      final Either<String, bool> res = await auth.logout();

      res.fold(
        (String error) {
          emit(
            state.copyWith(
              status: FormzStatus.submissionFailure,
              error: error,
            ),
          );
        },
        (bool success) {
          if (success) {
            emit(
              state.copyWith(
                status: FormzStatus.submissionSuccess,
                user: const Optional.absent(),
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: FormzStatus.submissionFailure,
              ),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      logger.e('Failed to log out: \n'
          'ERROR: $e \n'
          '$stackTrace');
    }
  }
}
