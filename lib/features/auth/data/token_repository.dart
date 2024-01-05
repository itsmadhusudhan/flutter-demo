import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

class TokenState {
  final String? accessToken;
  final String? refreshToken;

  TokenState({this.accessToken, this.refreshToken});
}

abstract class ITokenRepository {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> deleteTokens();
  Future<void> saveTokens(String accessToken, String refreshToken);
  Stream<TokenState?> get accessToken;
}

const accessTokenKey = "accessToken";
const refreshTokenKey = "refreshToken";

@LazySingleton(as: ITokenRepository)
class TokenRepository implements ITokenRepository {
  final FlutterSecureStorage secureStorage;

  TokenRepository({required this.secureStorage});

  final StreamController<TokenState?> _accessTokenController =
      StreamController<TokenState?>.broadcast();

  Stream<TokenState?> get accessToken => _accessTokenController.stream;

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.read(key: accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(key: refreshTokenKey);
  }

  @override
  Future<void> deleteTokens() async {
    await secureStorage.delete(key: accessTokenKey);
    await secureStorage.delete(key: refreshTokenKey);
  }

  @override
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await secureStorage.write(key: accessTokenKey, value: accessToken);
    await secureStorage.write(key: refreshTokenKey, value: refreshToken);

    _accessTokenController.add(TokenState(
      accessToken: accessToken,
      refreshToken: refreshToken,
    ));
  }
}
