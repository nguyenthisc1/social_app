import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:social_app/core/services/firebase/firebase_service.dart';

import 'core/core.dart';
import 'core/l10n/app_localizations.dart';
import 'presentations/auth/bloc/auth_bloc.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.init();
  await FirebaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get managers from dependency injection
    final themeManager = sl<ThemeManager>();
    final localeManager = sl<LocaleManager>();

    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: AnimatedBuilder(
        animation: Listenable.merge([themeManager, localeManager]),
        builder: (context, _) {
          return MaterialApp.router(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('vi'), // Vietnamese
            ],
            locale: localeManager.locale,
            // App configuration
            title: 'Social App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeManager.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
