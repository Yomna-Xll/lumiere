import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/network/api_error.dart';
import 'package:lumiere/features/auth/cubit/session_state.dart';
import 'package:lumiere/features/auth/data/auth_repository.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._repo) : super(SessionUnknown());

  final AuthRepository _repo;

  Future<void> check() async {
    emit(const SessionUnknown());
    if (!await _repo.hasSession()) {
      emit(SessionUnauthenticated());
      return;
    }
    try {
      final user = await _repo.getMe();
      emit(SessionAuthenticated(user));
    } on ApiError catch (e) {
      emit(e.isNetworkError ? SessionNetworkError() : SessionUnauthenticated());
    }
  }

  void expire() {
    if (state is SessionAuthenticated) emit(SessionExpired());
  }

  Future<void> logout() async {
    await _repo.logout();
    emit(SessionUnauthenticated());
  }
}
