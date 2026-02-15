import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: ForgotPasswordRoute.page),
    AutoRoute(
      page: MainRoute.page,
      children: [
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: ChatbotRoute.page),
        AutoRoute(page: OrdersRoute.page),
        AutoRoute(page: ProfileRoute.page),
      ],
    ),
    AutoRoute(page: FoodRoute.page),
    AutoRoute(page: MartRoute.page),
    AutoRoute(page: DeliveryRoute.page),
    AutoRoute(page: MarketRoute.page),
    AutoRoute(page: GiftRoute.page),
    AutoRoute(page: PartyRoute.page),
    AutoRoute(page: CoffeeRoute.page),
    AutoRoute(page: PromotionsRoute.page),
    AutoRoute(page: SearchRoute.page),
    AutoRoute(page: AddressRoute.page),
    AutoRoute(page: MapSelectionRoute.page),
  ];
}
