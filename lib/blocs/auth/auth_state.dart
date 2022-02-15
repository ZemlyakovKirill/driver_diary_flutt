part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthorizedState extends AuthState{
  final String token;

  AuthorizedState({required this.token});
}

class ErrorGoogleAuthState extends AuthState implements ErrorFlag{
  final String errorMessage;

  ErrorGoogleAuthState(this.errorMessage);
}

class ErrorVKAuthState extends AuthState implements ErrorFlag{
  final String errorMessage;

  ErrorVKAuthState(this.errorMessage);
}

class TokenSavedState extends AuthState{

}
class TokenReceivedState extends AuthState{

}
class UnAuthorizedState extends AuthState{

}


class UserCreatedState extends AuthState{

}

class ErrorCreatingState extends AuthState implements ErrorFlag{
  final String errorMessage;

  ErrorCreatingState(this.errorMessage);
}

class ErrorAuthorizingState extends AuthState implements ErrorFlag{
  final String errorMessage;

  ErrorAuthorizingState({required this.errorMessage});
}
