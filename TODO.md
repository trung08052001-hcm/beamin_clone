# Mart Screen Implementation Plan

## Information Gathered:
- API Endpoints from BE:
  - GET /products - get all products
  - GET /products/category/:catName - get products by category (e.g., "Rau củ", "Thịt cá", "Sữa", "Gia vị")
- Current project uses: flutter_bloc, dio, retrofit, get_it, auto_route
- Existing files: mart_screen.dart (Stateless), api_client.dart, restaurant_bloc.dart (can be referenced for pattern)

## Plan:
1. [] `lib/models/product.dart` - Create Product model with JSON serialization
2. [] `lib/models/product.g.dart` - Create generated file for JSON serialization
3. [] `lib/network/api_client.dart` - Add Product endpoints
4. [] `lib/network/api_client.g.dart` - Update generated API client
5. [] `lib/repositories/product_repository.dart` - Create Product repository
6. [] `lib/bloc/product/` - Create product_bloc, product_event, product_state files
7. [] `lib/screens/categories/mart_screen.dart` - Update to use BLoC and display products by category

## Dependent Files:
- api_client.dart (needs update for products endpoints)
- mart_screen.dart (main UI to update)
- Need to register ProductRepository and ProductBloc in injection.config.dart

## Followup steps:
- Run flutter pub run build_runner build to generate files
- Test the app to ensure products load correctly when
