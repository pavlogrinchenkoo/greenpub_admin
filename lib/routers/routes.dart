import 'package:auto_route/auto_route.dart';
import 'package:delivery/screens/auth/login_page/page.dart';
import 'package:delivery/screens/splash_page/page.dart';





part 'routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(path: '/', page: SplashRoute.page),
    AutoRoute(path: '/login', page: LoginRoute.page),
  ];
}

// dart run build_runner watch
// dart run build_runner build
