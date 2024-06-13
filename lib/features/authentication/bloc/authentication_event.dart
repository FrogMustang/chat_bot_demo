part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged({
    required this.newUser,
  });

  final AppUser? newUser;

  @override
  List<Object?> get props => [newUser];
}

class AuthenticationLoggedIn extends AuthenticationEvent {
  const AuthenticationLoggedIn({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => [
    username,
    password,
  ];
}

class AuthenticationSignedUp extends AuthenticationEvent {
  const AuthenticationSignedUp({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => [
    username,
    password,
  ];
}

class AuthenticationLoggedOut extends AuthenticationEvent {
  const AuthenticationLoggedOut();

  @override
  List<Object> get props => [];
}
