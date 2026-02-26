// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'bloc/auth/auth_bloc.dart' as _i739;
import 'bloc/restaurant/restaurant_bloc.dart' as _i25;
import 'bloc/splash/splash_bloc.dart' as _i12;
import 'network/api_client.dart' as _i96;
import 'repositories/restaurant_repository.dart' as _i751;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.factory<_i739.AuthBloc>(() => _i739.AuthBloc());
    gh.factory<_i12.SplashBloc>(() => _i12.SplashBloc());
    gh.lazySingleton<_i361.Dio>(() => dioModule.dio);
    gh.factory<_i96.ApiClient>(() => _i96.ApiClient(gh<_i361.Dio>()));
    gh.factory<_i751.RestaurantRepository>(
      () => _i751.RestaurantRepository(gh<_i96.ApiClient>()),
    );
    gh.factory<_i25.RestaurantBloc>(
      () => _i25.RestaurantBloc(gh<_i751.RestaurantRepository>()),
    );
    return this;
  }
}

class _$DioModule extends _i96.DioModule {}
