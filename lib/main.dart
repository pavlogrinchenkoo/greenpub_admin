import 'package:delivery/screens/auth/login_page/bloc/bloc.dart';
import 'package:delivery/screens/splash_page/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'routers/routes.dart';
import 'style.dart';

Future<void> main() async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AppRouter _appRouter = AppRouter();

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
            scaffoldBackgroundColor: BC.white,
            bottomSheetTheme:
                const BottomSheetThemeData(backgroundColor: Colors.transparent),
          ),
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
        ));
  }
}
