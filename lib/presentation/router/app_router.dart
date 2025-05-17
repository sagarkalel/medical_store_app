import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_store_app/core/constants/app_constants.dart';
import 'package:medical_store_app/logic/auth/auth_cubit.dart';
import 'package:medical_store_app/presentation/screens/admin/add_edit_product_screen.dart';
import 'package:medical_store_app/presentation/screens/admin/manage_products_screen.dart';
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
      redirect: _handleRedirect,
      routes: _routes,
    );
  }

  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final bool isLoggedIn = authCubit.state.status == AuthStatus.authenticated;
    final bool isGoingToLogin = state.matchedLocation == AppRoutes.login;
    final bool isGoingToSplash = state.matchedLocation == AppRoutes.splash;

    // If not logged in and not going to login or splash, redirect to login
    if (!isLoggedIn && !isGoingToLogin && !isGoingToSplash) {
      return AppRoutes.login;
    }

    // If logged in and going to login, redirect to appropriate dashboard
    if (isLoggedIn && isGoingToLogin) {
      final isAdmin = authCubit.state.isAdmin;
      return isAdmin ? AppRoutes.manageProducts : AppRoutes.productList;
    }

    // No redirection needed
    return null;
  }

  List<RouteBase> get _routes => [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        // User Routes
        GoRoute(
          path: AppRoutes.productList,
          builder: (context, state) => const ProductListScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.productDetail}/:productId',
          builder: (context, state) {
            final productId = state.pathParameters['productId']!;
            return ProductDetailScreen(productId: productId);
          },
        ),
        // Admin Routes
        // GoRoute(
        //   path: AppRoutes.adminDashboard,
        //   builder: (context, state) => const AdminDashboardScreen(),
        // ),
        GoRoute(
          path: AppRoutes.manageProducts,
          builder: (context, state) => const ManageProductsScreen(),
        ),
        GoRoute(
          path: AppRoutes.addProduct,
          builder: (context, state) => const AddEditProductScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.editProduct}/:productId',
          builder: (context, state) {
            final productId = state.pathParameters['productId']!;
            return AddEditProductScreen(product: null);
          },
        ),
      ];
}
