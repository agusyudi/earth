import 'dart:io';

import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'cores/router.dart';
import 'cores/theme/theme.dart';
import 'cores/theme/theme_service.dart';

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late EncryptedSharedPreferences sharedPref;
late EncryptedSharedPreferences sharedPrefLifeTime;
bool isUserLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EncryptedSharedPreferences.initialize("aZ7@t!G2Kd#Lp9^x");
  sharedPref = EncryptedSharedPreferences.getInstance();
  sharedPrefLifeTime = EncryptedSharedPreferences.getInstance();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    await dotenv.load(fileName: ".env.example");
  }

  GoRouter.optionURLReflectsImperativeAPIs = true;

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeService())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = BaseRouter().getRouter();

    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return GetMaterialApp.router(
          title: 'GIS',
          debugShowCheckedModeBanner: false,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          theme: Themes().lightTheme,
          darkTheme: Themes().darkTheme,
          themeMode: themeService.getThemeMode(),
          locale: const Locale('id', 'ID'),
          fallbackLocale: const Locale('id', 'ID'),
          localeResolutionCallback: (locale, supported) {
            return const Locale('id', 'ID');
          },
          supportedLocales: const [Locale('id', 'ID')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
