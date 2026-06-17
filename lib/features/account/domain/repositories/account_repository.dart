import 'package:coiner/core/network/result/api_result.dart';
import 'package:coiner/features/account/domain/models/current_user.dart';

abstract class AccountRepository {
  Future<CurrentUser?> getCachedUser();
  Future<void> setCachedUser(CurrentUser? user);
  Future<ApiResult<CurrentUser>> getRemoteUser();
  Future<bool> deleteAccount();
}
