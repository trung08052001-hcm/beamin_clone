import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../models/restaurant.dart';

part 'api_client.g.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: 'http://10.0.2.2:3000',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
}

@RestApi()
@injectable
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(Dio dio) = _ApiClient;

  @GET('/restaurants')
  Future<List<Restaurant>> getRestaurants();
}

