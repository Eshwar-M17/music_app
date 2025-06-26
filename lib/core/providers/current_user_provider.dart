import 'package:c_lient/features/auth/model/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  User? build() {
    return null;
  }

  void addUser(User user) {
    state = user;
  }
}
