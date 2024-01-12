import 'package:delivery/api/cache.dart';
import 'package:delivery/api/firestore_category/request.dart';
import 'package:delivery/api/firestore_orders/request.dart';
import 'package:delivery/api/firestore_product/request.dart';
import 'package:delivery/api/firestore_shared/request.dart';
import 'package:delivery/api/firestore_tags/request.dart';
import 'package:delivery/api/firestore_user/request.dart';
import 'package:delivery/api/system/request.dart';
import 'package:delivery/firebase_options.dart';
import 'package:delivery/screens/add_product_page/bloc/bloc.dart';
import 'package:delivery/screens/auth/login_page/bloc/bloc.dart';
import 'package:delivery/screens/categories_page/bloc/bloc.dart';
import 'package:delivery/screens/order_page/bloc/bloc.dart';
import 'package:delivery/screens/orders_page/bloc/bloc.dart';
import 'package:delivery/screens/products_page/bloc/bloc.dart';
import 'package:delivery/screens/shares_page/bloc/bloc.dart';
import 'package:delivery/screens/splash_page/bloc/bloc.dart';
import 'package:delivery/screens/system_page/bloc/bloc.dart';
import 'package:delivery/screens/tags_page/bloc/bloc.dart';
import 'package:delivery/screens/user_page/bloc/bloc.dart';
import 'package:delivery/screens/users_page/bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'routers/routes.dart';
import 'screens/orders_page/widgets/show_product/bloc/bloc.dart';
import 'screens/product_page/bloc/bloc.dart';
import 'style.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter _appRouter = AppRouter();
  final FirestoreUserApi _firestoreApi = FirestoreUserApi();
  final FirestoreOrdersApi _firestoreOrdersApi = FirestoreOrdersApi();
  final FirestoreProductApi _firestoreProductApi = FirestoreProductApi();
  final FirestoreCategoryApi _firestoreCategoryApi = FirestoreCategoryApi();
  final FirestoreTagsApi _firestoreTagsApi = FirestoreTagsApi();
  final SharedApi _sharedApi = SharedApi();
  final SystemApi _systemApi = SystemApi();
  final Cache _cache = Cache();

  @override
  Widget build(BuildContext buildContext) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => SplashCubit(),
          ),
          BlocProvider(
            create: (_) => LoginCubit(),
          ),
          BlocProvider(
            create: (_) => UsersCubit(_firestoreApi),
          ),
          BlocProvider(
            create: (_) => OrdersCubit(
                _firestoreApi, _firestoreOrdersApi, _firestoreProductApi),
          ),
          BlocProvider(
            create: (_) => UserCubit(_firestoreApi),
          ),
          BlocProvider(
            create: (_) => OrderCubit(
                _firestoreApi, _firestoreOrdersApi, _firestoreProductApi),
          ),
          BlocProvider(
            create: (_) => ProductsCubit(_firestoreProductApi, _cache),
          ),
          BlocProvider(
            create: (_) => ProductCubit(_firestoreProductApi,
                _firestoreCategoryApi, _firestoreTagsApi, _cache),
          ),
          BlocProvider(
            create: (_) => AddProductCubit(
                _firestoreProductApi, _firestoreCategoryApi, _firestoreTagsApi),
          ),
          BlocProvider(
            create: (_) => CategoryCubit(_firestoreCategoryApi),
          ),
          BlocProvider(
            create: (_) => TagsCubit(_firestoreTagsApi),
          ),
          BlocProvider(
            create: (_) => SharesCubit(_sharedApi),
          ),
          BlocProvider(
            create: (_) => ShowProductCubit(
                _firestoreProductApi, _firestoreOrdersApi, _firestoreApi, _cache),
          ),
          BlocProvider(
            create: (_) => SystemCubit(_systemApi),
          ),
        ],
        child: MaterialApp.router(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('en'),
          themeMode: ThemeMode.light,
          theme: ThemeData(
            scaffoldBackgroundColor: BC.black,
            bottomSheetTheme:
                const BottomSheetThemeData(backgroundColor: Colors.transparent),
          ),
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
        ));
  }
}
