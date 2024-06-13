part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  /// Tracks the status of the login / register process
  final FormzStatus status;
  final AppUser? user;
  final String? error;

  const AuthenticationState({
    this.status = FormzStatus.pure,
    this.user,
    this.error,
  });

  AuthenticationState copyWith({
    FormzStatus? status,
    Optional<AppUser>? user,
    String? error,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user != null ? user.orNull : this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    error,
  ];
}
