import 'dart:convert';

import 'package:coiner/core/logging/app_logger.dart';
import 'package:coiner/core/network/dio/dio_client.dart';
import 'package:coiner/core/network/result/api_result.dart';
import 'package:coiner/core/storage/cache/cache_storage_impl.dart';
import 'package:coiner/core/storage/storage_base.dart';
import 'package:coiner/features/account/domain/models/current_user.dart';
import 'package:coiner/features/account/domain/repositories/account_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountRepositoryImpl implements AccountRepository {
  final DioClient _dioClient;
  final StorageBase _cacheStorage;

  AccountRepositoryImpl(this._dioClient, this._cacheStorage);

  @override
  Future<CurrentUser?> getCachedUser() async {
    try {
      final cachedString = await _cacheStorage.get("user") as String?;
      if (cachedString != null) {
        return CurrentUser.fromJson(jsonDecode(cachedString));
      }
    } catch (e) {
      AppLogger.warning("Cache read failed", e, StackTrace.current);
    }
    return null;
  }

  @override
  Future<void> setCachedUser(CurrentUser? user) async {
    try {
      user != null ? await _cacheStorage.set("user", user.toJson()) : await _cacheStorage.remove("user");
    } catch (e) {
      AppLogger.warning("Cache write failed", e, StackTrace.current);
    }
  }

  @override
  Future<ApiResult<CurrentUser>> getRemoteUser() async {
    final rs = await _dioClient.getData<CurrentUser>(
      "/api/user/me", 
      parser: (json) => CurrentUser.fromJson(json)
    );

    if (rs.isSuccess && rs.data != null) {
      await _cacheStorage.set("user", rs.data!.toJson());
      return ApiResult.success(rs.data);
    }
    
    return ApiResult.failure(rs.failure!);
  }
    
  @override
  Future<bool> deleteAccount() async {
    throw UnimplementedError("delete account method not implemented");
  }

}

final accountRepositoryProvider = Provider<AccountRepository>((ref) => AccountRepositoryImpl(
  ref.read(dioClientProvider),
  ref.read(cacheStorageProvider)
));