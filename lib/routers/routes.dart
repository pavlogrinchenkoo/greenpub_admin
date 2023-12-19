import 'package:auto_route/auto_route.dart';
import 'package:delivery/screens/add_product_page/page.dart';
import 'package:delivery/screens/auth/login_page/page.dart';
import 'package:delivery/screens/categories_page/page.dart';
import 'package:delivery/screens/order_page/page.dart';
import 'package:delivery/screens/product_page/page.dart';
import 'package:delivery/screens/products_page/page.dart';
import 'package:delivery/screens/splash_page/page.dart';
import 'package:delivery/screens/orders_page/page.dart';
import 'package:delivery/screens/sidebar/sidebar.dart';
import 'package:delivery/screens/tags_page/page.dart';
import 'package:delivery/screens/user_page/page.dart';
import 'package:delivery/screens/users_page/page.dart';
import 'package:flutter/material.dart';

part 'routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(path: '/', page: SplashRoute.page),
    AutoRoute(path: '/login', page: LoginRoute.page),
    AutoRoute(path: '/sidebar', page: SideBarRoute.page, children: [
      AutoRoute(path: 'orders', page: OrdersRoute.page),
      AutoRoute(path: 'users', page: UsersRoute.page),
      AutoRoute(path: 'products', page: ProductsRoute.page),
      AutoRoute(path: 'categories', page: CategoriesRoute.page),
      AutoRoute(path: 'tags', page: TagsRoute.page),
    ]),
    AutoRoute(path: '/user/:uid', page: UserRoute.page),
    AutoRoute(path: '/order/:uid', page: OrderRoute.page),
    AutoRoute(path: '/product/:id', page: ProductRoute.page),
    AutoRoute(path: '/add-product', page: AddProductRoute.page),
  ];
}

// dart run build_runner watch
// dart run build_runner build
