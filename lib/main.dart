import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_store_app/data/data_providers/hive_helper.dart';
import 'package:medical_store_app/data/repositories/auth_repository.dart';
import 'package:medical_store_app/data/repositories/product_repository.dart';
import 'package:medical_store_app/logic/auth/auth_cubit.dart';
import 'package:medical_store_app/logic/product/product_cubit.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HiveHelper
  await HiveHelper.initHive();

  // Initialize repositories
  final authRepository = AuthRepository();
  final productRepository = ProductRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository),
        ),
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(productRepository),
        ),
      ],
      child: const MedicalStoreApp(),
    ),
  );
}
