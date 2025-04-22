import '../../local/caches_keys.dart';
import '../../local/secure_storage_helper.dart';

bool isUserLoggedIn = false;

Future<void> checkIfUserIsLoggedIn() async {
  final cachedUserId = await SecureStorage.readToken(
    CacheKeys.cachedUserId,
  );

  if (cachedUserId == null || cachedUserId.isEmpty) {
    isUserLoggedIn = false;
  } else {
    isUserLoggedIn = true;
  }
}
