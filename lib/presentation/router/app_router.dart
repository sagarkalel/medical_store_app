import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_store_app/core/constants/app_constants.dart';
import 'package:medical_store_app/data/models/product_model.dart';
import 'package:medical_store_app/logic/auth/auth_cubit.dart';
import 'package:medical_store_app/presentation/screens/admin/add_edit_product_screen.dart';
import 'package:medical_store_app/presentation/screens/admin/admin_dashboard_screen.dart';
import 'package:medical_store_app/presentation/screens/auth/login_screen.dart';
import 'package:medical_store_app/presentation/screens/splash/splash_screen.dart';
import 'package:medical_store_app/presentation/screens/user/product_detail_screen.dart';
import 'package:medical_store_app/presentation/screens/user/product_list_screen.dart';

class AppRouter {
  final AuthCubit authCubit;
  late final GoRouter router;

  AppRouter({required this.authCubit}) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authCubit.stream),
      redirect: _handleRedirect,
      routes: _routes,
    );
  }

  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authState = authCubit.state;
    final isLoggedIn = authState.status == AuthStatus.authenticated;
    final isLoggingOut = authState.status == AuthStatus.loading;
    final isSplash = state.matchedLocation == AppRoutes.splash;
    final isLogin = state.matchedLocation == AppRoutes.login;

    // Handle splash screen redirect
    if (isSplash) {
      return isLoggedIn
          ? (authState.isAdmin
              ? AppRoutes.manageProducts
              : AppRoutes.productList)
          : AppRoutes.login;
    }

    // Redirect to login if not authenticated
    if (!isLoggedIn && !isLogin && !isLoggingOut) {
      return AppRoutes.login;
    }

    // Redirect from login to home if already authenticated
    if (isLoggedIn && isLogin) {
      return authState.isAdmin
          ? AppRoutes.manageProducts
          : AppRoutes.productList;
    }

    // No redirect needed
    return null;
  }

  List<RouteBase> get _routes => [
        GoRoute(
          path: AppRoutes.splash,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.productList,
          builder: (_, __) => const ProductListScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.productDetail}/:productId',
          builder: (_, state) => ProductDetailScreen(
            productId: state.pathParameters['productId']!,
          ),
        ),
        GoRoute(
          path: AppRoutes.manageProducts,
          builder: (_, __) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.addProduct,
          builder: (_, __) => const AddEditProductScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.editProduct}/:productId',
          builder: (_, state) => AddEditProductScreen(
            product: state.extra as ProductModel?,
          ),
        ),
      ];
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
