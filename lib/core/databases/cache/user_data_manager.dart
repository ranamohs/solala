

import 'cache_helper.dart';

class UserDataManager {
  final CacheHelper _cacheHelper;

  String? _cachedUserEmail;
  String? _cachedUserName;
  String? _cachedUserPhoneNumber;
  String? _cachedUserLogoUrl;
  int? _cachedUserId;

  UserDataManager(this._cacheHelper);

  void saveUserName({required String name}) {
    _cacheHelper.saveData(key: 'name', value: name);
    _cachedUserName = name;
  }

  void saveUserId({required int id}) {
    _cacheHelper.saveData(key: 'id', value: id);
    _cachedUserId = id;
  }

  String? getUserName() {
    _cachedUserName ??= _cacheHelper.getData(key: 'name');
    return _cachedUserName;
  }


  int? getUserId() {
    if (_cachedUserId != null) return _cachedUserId;
    final raw = _cacheHelper.getData(key: 'id');
    if (raw is int) {
      _cachedUserId = raw;
    } else if (raw is String) {
      _cachedUserId = int.tryParse(raw);
    } else if (raw is num) {
      _cachedUserId = raw.toInt();
    } else {
      _cachedUserId = null;
    }
    return _cachedUserId;
  }

  void saveUserEmail({required String email}) {
    _cacheHelper.saveData(key: 'email', value: email);
    _cachedUserEmail = email;
  }

  String? getUserEmail() {
    _cachedUserEmail ??= _cacheHelper.getData(key: 'email');
    return _cachedUserEmail;
  }

  void saveUserPhoneNumber({required String phoneNumber}) {
    _cacheHelper.saveData(key: 'phoneNumber', value: phoneNumber);
    _cachedUserPhoneNumber = phoneNumber;
  }

  String? getUserPhoneNumber() {
    _cachedUserPhoneNumber ??= _cacheHelper.getData(key: 'phoneNumber');
    return _cachedUserPhoneNumber;
  }

  void saveUserAvatarUrl({required String avatar}) {
    _cacheHelper.saveData(key: 'avatarUrl', value: avatar);
    _cachedUserLogoUrl = avatar;
  }

  String? getUserAvatarUrl() {
    _cachedUserLogoUrl ??= _cacheHelper.getData(key: 'avatarUrl');
    return _cachedUserLogoUrl;
  }

  void saveUserStatus({required bool isGuest}) {
    _cacheHelper.saveData(key: 'isGuest', value: isGuest);
  }

  bool? getUserStatus() {
    return _cacheHelper.getData(key: 'isGuest');
  }

  Future<void> clearAllUserData() async {
    await _cacheHelper.removeData(key: 'id');
    await _cacheHelper.removeData(key: 'name');
    await _cacheHelper.removeData(key: 'email');
    await _cacheHelper.removeData(key: 'phoneNumber');
    await _cacheHelper.removeData(key: 'avatarUrl');
    await _cacheHelper.removeData(key: 'isGuest');

    _cachedUserId = null;
    _cachedUserName = null;
    _cachedUserEmail = null;
    _cachedUserPhoneNumber = null;
    _cachedUserLogoUrl = null;
  }
}
