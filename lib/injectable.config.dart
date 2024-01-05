// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'core/network/api_client.dart' as _i6;
import 'core/network/connection_status.dart' as _i3;
import 'features/auth/data/token_repository.dart' as _i5;
import 'features/auth/data/user_repository.dart' as _i7;
import 'injectable.dart' as _i8;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i3.ConnectionStatusSingleton>(
      () => _i3.ConnectionStatusSingleton(),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i4.FlutterSecureStorage>(
        () => registerModule.createFlutterSecureStorage());
    gh.lazySingleton<_i5.ITokenRepository>(() =>
        _i5.TokenRepository(secureStorage: gh<_i4.FlutterSecureStorage>()));
    gh.lazySingleton<_i6.ApiClient>(
        () => _i6.ApiClient(gh<_i5.ITokenRepository>()));
    gh.lazySingleton<_i7.IUserRepository>(
        () => _i7.UserRepository(apiClient: gh<_i6.ApiClient>()));
    return this;
  }
}

class _$RegisterModule extends _i8.RegisterModule {}
