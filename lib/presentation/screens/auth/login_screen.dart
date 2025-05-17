import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_store_app/core/constants/app_constants.dart';
import 'package:medical_store_app/core/theme/app_colors.dart';
import 'package:medical_store_app/core/theme/text_styles.dart';
import 'package:medical_store_app/core/utils/extensions.dart';
import 'package:medical_store_app/logic/auth/auth_cubit.dart';
import 'package:medical_store_app/presentation/animations/fade_animation.dart';
import 'package:medical_store_app/presentation/widgets/common/custom_button.dart';
import 'package:medical_store_app/presentation/widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // For demo purposes, prefill with admin credentials
    _usernameController.text = AppConstants.adminUsername;
    _passwordController.text = AppConstants.adminPassword;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context
          .read<AuthCubit>()
          .login(_usernameController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            // Navigate to the appropriate screen based on user role
            if (state.isAdmin) {
              context.go(AppRoutes.manageProducts);
            } else {
              context.go(AppRoutes.productList);
            }
          } else if (state.errorMessage != null) {
            // Show error snackbar
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),

                      // App logo and name
                      FadeAnimation(
                        delayInSec: 0.2,
                        child: Column(
                          children: [
                            Icon(
                              Icons.medical_services_rounded,
                              size: 64,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppConstants.appName,
                              style: TextStyles.heading1,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Login form
                      FadeAnimation(
                        delayInSec: 0.4,
                        child: Card(
                          elevation: AppConstants.defaultElevation,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.defaultBorderRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Login',
                                    style: TextStyles.heading2,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),

                                  // Username field
                                  CustomTextField(
                                    controller: _usernameController,
                                    label: 'Username',
                                    hint: 'Enter your username',
                                    prefixIcon: Icons.person_outline,
                                    // validator: Validators.required,
                                  ),
                                  const SizedBox(height: 16),

                                  // Password field
                                  CustomTextField(
                                    controller: _passwordController,
                                    label: 'Password',
                                    hint: 'Enter your password',
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: _obscurePassword,
                                    // validator: Validators.required,
                                    suffixIcon: _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    onSuffixIconPressed:
                                        _togglePasswordVisibility,
                                  ),
                                  const SizedBox(height: 16),

                                  // Remember me checkbox
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          onChanged: _toggleRememberMe,
                                          activeColor: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Remember me',
                                        style: TextStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),

                                  // Login button

                                  CustomButton(
                                    text: 'Login',
                                    onPressed: _handleLogin,
                                    isFullWidth: true,
                                    isLoading:
                                        state.status == AuthStatus.loading,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).animate().slideY(
                              begin: 0.2,
                              end: 0,
                              delay: 400.ms,
                              duration: 600.ms,
                              curve: Curves.easeOutQuad,
                            ),
                      ),

                      const SizedBox(height: 24),

                      // Demo info
                      FadeAnimation(
                        delayInSec: 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'For demo purposes:',
                              style: TextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      FadeAnimation(
                        delayInSec: 0.7,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Admin: ',
                                  style: TextStyles.bodySmall,
                                ),
                                Text(
                                  '${AppConstants.adminUsername} / ${AppConstants.adminPassword}',
                                  style: TextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'User: ',
                                  style: TextStyles.bodySmall,
                                ),
                                Text(
                                  '${AppConstants.userUsername} / ${AppConstants.userPassword}',
                                  style: TextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
