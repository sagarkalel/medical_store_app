import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_store_app/core/theme/app_theme.dart';
import 'package:medical_store_app/logic/auth/auth_cubit.dart';
import 'package:medical_store_app/presentation/router/app_router.dart';

class MedicalStoreApp extends StatefulWidget {
  const MedicalStoreApp({super.key});

  @override
  State<MedicalStoreApp> createState() => _MedicalStoreAppState();
}

class _MedicalStoreAppState extends State<MedicalStoreApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(authCubit: context.read<AuthCubit>());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: 'Medical Store App',
        theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, // You can change this to system or dark
        debugShowCheckedModeBanner: false,
        routerDelegate: _appRouter.router.routerDelegate,
        routeInformationParser: _appRouter.router.routeInformationParser,
        routeInformationProvider: _appRouter.router.routeInformationProvider,
      ),
    );
  }
}
