import 'package:c_lient/core/failure/failure.dart';
import 'package:c_lient/core/providers/current_user_provider.dart';
import 'package:c_lient/features/auth/model/user.dart';
import 'package:c_lient/features/auth/repositories/auth_local_repositery.dart';
import 'package:c_lient/features/auth/repositories/auth_remort_reposiitery.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemortRepositery _authRemortRepositery;
  late AuthLocalRepositery _authLocalRepositery;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<User>? build() {
    _authRemortRepositery = ref.watch(authRemortRepositeryProvider);
    _authLocalRepositery = ref.watch(authLocalRepositeryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);

    return null;
  }

  Future<void> sharedPreferencesIntilize() async {
    await _authLocalRepositery.sharedPreferencesIntilize();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRemortRepositery.signUp(
      name: name,
      email: email,
      password: password,
    );

    res.fold(
      (Failure exc) {
        state = AsyncValue.error(exc.message, StackTrace.current);
      },
      (User user) {
        state = AsyncValue.data(user);
      },
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    state = AsyncValue.loading();
    final res = await _authRemortRepositery.signIn(
      email: email,
      password: password,
    );
    res.fold(
      (Failure exc) {
        state = AsyncValue.error(exc.message, StackTrace.current);
      },
      (User user) {
        _currentUserNotifier.addUser(user);
        _authLocalRepositery.setToken(user.token);
        state = AsyncValue.data(user);
      },
    );
  }

  Future<void> getUserData() async {
    state = AsyncValue.loading();
    final token = await _authLocalRepositery.getToken();
    if (token != null) {
      final res = await _authRemortRepositery.getUserData(token: token);
      res.fold(
        (Failure exc) {
          state = AsyncValue.error(exc.message, StackTrace.current);
        },
        (User user) {
          _currentUserNotifier.addUser(user);
          _authLocalRepositery.setToken(user.token);
          state = AsyncValue.data(user);
        },
      );
    }
  }
}
