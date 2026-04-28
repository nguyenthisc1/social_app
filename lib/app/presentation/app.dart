import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/app/di/service_locator.dart';
import 'package:social_app/app/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:social_app/app/routes/app_router.dart';
import 'package:social_app/core/l10n/app_localizations.dart';
import 'package:social_app/core/locale/locale_manager.dart';
import 'package:social_app/core/theme/app_theme.dart';
import 'package:social_app/core/theme/theme_manager.dart';
import 'package:social_app/core/utils/app_constants.dart';
import 'package:social_app/app/presentation/session_scope.dart';
import 'package:social_app/features/auth/application/bloc/auth_bloc.dart';
import 'package:social_app/features/notification/application/bloc/in_app_notification/in_app_notification_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = sl<ThemeManager>();
    final localeManager = sl<LocaleManager>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(lazy: false, create: (_) => sl<AuthBloc>()),
        BlocProvider<InternetConnectionCubit>(
          lazy: false,
          create: (_) => sl<InternetConnectionCubit>(),
        ),
        BlocProvider(lazy: false, create: (_) => sl<InAppNotificationBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(ScreenUtilSize.width, ScreenUtilSize.height),
        builder: (context, child) {
          return AnimatedBuilder(
            animation: Listenable.merge([themeManager, localeManager]),
            builder: (context, _) {
              return MaterialApp.router(
                builder: (context, child) {
                  final authState = context.watch<AuthBloc>().state;
                  final isAuthenticated = authState is AuthAuthenticated;

                  return SessionScope(
                    key: ValueKey('session-$isAuthenticated'),
                    isAuthenticated: isAuthenticated,
                    child: child ?? const SizedBox.shrink(),
                  );
                },
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
                title: 'Social App',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeManager.themeMode,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
