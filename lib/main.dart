import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/network/dio_client.dart';
import 'package:lumiere/core/storage/token_storage.dart';
import 'package:lumiere/core/theme/app_theme.dart';
import 'package:lumiere/features/auth/cubit/session_cubit.dart';
import 'package:lumiere/features/auth/cubit/session_state.dart';
import 'package:lumiere/features/auth/data/auth_repository.dart';
import 'package:lumiere/features/auth/data/auth_repository_impl.dart';
import 'package:lumiere/features/auth/ui/login_screen.dart';
import 'package:lumiere/features/auth/ui/splash_screen.dart';
import 'package:lumiere/features/categories/data/categories_repository.dart';
import 'package:lumiere/features/categories/data/categories_repository_impl.dart';
import 'package:lumiere/features/main_ui/main_shell.dart';
import 'package:lumiere/features/main_ui/session_expired_screen.dart';
import 'package:lumiere/features/products/data/products_repository.dart';
import 'package:lumiere/features/products/data/products_repository_impl.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenStorage = TokenStorage();
  late final SessionCubit sessionCubit;

  final dio = DioClient.create(
    tokenStorage: tokenStorage,
    onSessionExpired: () => sessionCubit.expire(),
  );

  final AuthRepository authRepository = AuthRepositoryImpl(dio, tokenStorage);
  final ProductsRepository productsRepository = ProductsRepositoryImpl(dio);
  final CategoriesRepository categoriesRepository = CategoriesRepositoryImpl(
    dio,
  );
  sessionCubit = SessionCubit(authRepository);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: productsRepository),
        RepositoryProvider.value(value: categoriesRepository),
      ],
      child: BlocProvider.value(value: sessionCubit, child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void goTo(Widget screen) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.light,
      home: const SplashScreen(),
      builder: (context, child) => BlocListener<SessionCubit, SessionState>(
        listener: (context, state) {
          switch (state) {
            case SessionAuthenticated():
              goTo(MainShell());
            case SessionUnauthenticated():
              goTo(LoginScreen());
            case SessionExpired():
              goTo(SessionExpiredScreen());
            case SessionUnknown():
            case SessionNetworkError():
              break;
          }
        },
        child: child!,
      ),
    );
  }
}
