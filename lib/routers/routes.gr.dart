// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'routes.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AddProductRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AddProductPage(),
      );
    },
    CategoriesRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CategoriesPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    OrderRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<OrderRouteArgs>(
          orElse: () => OrderRouteArgs(uid: pathParams.optString('uid')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: OrderPage(
          key: args.key,
          uid: args.uid,
        ),
      );
    },
    OrdersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OrdersPage(),
      );
    },
    ProductRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProductRouteArgs>(
          orElse: () => ProductRouteArgs(id: pathParams.optString('id')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProductPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    ProductsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProductsPage(),
      );
    },
    SideBarRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SideBarPage(),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    TagsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TagsPage(),
      );
    },
    UserRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<UserRouteArgs>(
          orElse: () => UserRouteArgs(uid: pathParams.optString('uid')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: UserPage(
          key: args.key,
          uid: args.uid,
        ),
      );
    },
    UsersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UsersPage(),
      );
    },
  };
}

/// generated route for
/// [AddProductPage]
class AddProductRoute extends PageRouteInfo<void> {
  const AddProductRoute({List<PageRouteInfo>? children})
      : super(
          AddProductRoute.name,
          initialChildren: children,
        );

  static const String name = 'AddProductRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CategoriesPage]
class CategoriesRoute extends PageRouteInfo<void> {
  const CategoriesRoute({List<PageRouteInfo>? children})
      : super(
          CategoriesRoute.name,
          initialChildren: children,
        );

  static const String name = 'CategoriesRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OrderPage]
class OrderRoute extends PageRouteInfo<OrderRouteArgs> {
  OrderRoute({
    Key? key,
    String? uid,
    List<PageRouteInfo>? children,
  }) : super(
          OrderRoute.name,
          args: OrderRouteArgs(
            key: key,
            uid: uid,
          ),
          rawPathParams: {'uid': uid},
          initialChildren: children,
        );

  static const String name = 'OrderRoute';

  static const PageInfo<OrderRouteArgs> page = PageInfo<OrderRouteArgs>(name);
}

class OrderRouteArgs {
  const OrderRouteArgs({
    this.key,
    this.uid,
  });

  final Key? key;

  final String? uid;

  @override
  String toString() {
    return 'OrderRouteArgs{key: $key, uid: $uid}';
  }
}

/// generated route for
/// [OrdersPage]
class OrdersRoute extends PageRouteInfo<void> {
  const OrdersRoute({List<PageRouteInfo>? children})
      : super(
          OrdersRoute.name,
          initialChildren: children,
        );

  static const String name = 'OrdersRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProductPage]
class ProductRoute extends PageRouteInfo<ProductRouteArgs> {
  ProductRoute({
    Key? key,
    String? id,
    List<PageRouteInfo>? children,
  }) : super(
          ProductRoute.name,
          args: ProductRouteArgs(
            key: key,
            id: id,
          ),
          rawPathParams: {'id': id},
          initialChildren: children,
        );

  static const String name = 'ProductRoute';

  static const PageInfo<ProductRouteArgs> page =
      PageInfo<ProductRouteArgs>(name);
}

class ProductRouteArgs {
  const ProductRouteArgs({
    this.key,
    this.id,
  });

  final Key? key;

  final String? id;

  @override
  String toString() {
    return 'ProductRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [ProductsPage]
class ProductsRoute extends PageRouteInfo<void> {
  const ProductsRoute({List<PageRouteInfo>? children})
      : super(
          ProductsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SideBarPage]
class SideBarRoute extends PageRouteInfo<void> {
  const SideBarRoute({List<PageRouteInfo>? children})
      : super(
          SideBarRoute.name,
          initialChildren: children,
        );

  static const String name = 'SideBarRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [TagsPage]
class TagsRoute extends PageRouteInfo<void> {
  const TagsRoute({List<PageRouteInfo>? children})
      : super(
          TagsRoute.name,
          initialChildren: children,
        );

  static const String name = 'TagsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UserPage]
class UserRoute extends PageRouteInfo<UserRouteArgs> {
  UserRoute({
    Key? key,
    String? uid,
    List<PageRouteInfo>? children,
  }) : super(
          UserRoute.name,
          args: UserRouteArgs(
            key: key,
            uid: uid,
          ),
          rawPathParams: {'uid': uid},
          initialChildren: children,
        );

  static const String name = 'UserRoute';

  static const PageInfo<UserRouteArgs> page = PageInfo<UserRouteArgs>(name);
}

class UserRouteArgs {
  const UserRouteArgs({
    this.key,
    this.uid,
  });

  final Key? key;

  final String? uid;

  @override
  String toString() {
    return 'UserRouteArgs{key: $key, uid: $uid}';
  }
}

/// generated route for
/// [UsersPage]
class UsersRoute extends PageRouteInfo<void> {
  const UsersRoute({List<PageRouteInfo>? children})
      : super(
          UsersRoute.name,
          initialChildren: children,
        );

  static const String name = 'UsersRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
