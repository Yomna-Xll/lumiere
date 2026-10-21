import 'package:equatable/equatable.dart';
import 'package:lumiere/features/auth/data/user_model.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionUnknown extends SessionState {
  const SessionUnknown();
}

class SessionAuthenticated extends SessionState {
  final UserModel user;
  const SessionAuthenticated(this.user);

  @override
  List<Object?> get props => [user.id];
}

class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

class SessionExpired extends SessionState {
  const SessionExpired();
}

class SessionNetworkError extends SessionState {
  const SessionNetworkError();
}