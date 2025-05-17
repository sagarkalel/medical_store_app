import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_store_app/core/constants/app_constants.dart';
import 'package:medical_store_app/core/theme/app_colors.dart';
import 'package:medical_store_app/core/theme/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to login screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Icon(
              Icons.medical_services_rounded,
              size: 80,
              color: Colors.white,
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(delay: 200.ms, duration: 600.ms),
            const SizedBox(height: 24),

            // App name
            Text(
              AppConstants.appName,
              style: TextStyles.heading1.copyWith(
                color: Colors.white,
                fontSize: 28,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 600.ms),

            const SizedBox(height: 8),

            // App tagline
            Text(
              'Your Health, Our Priority',
              style: TextStyles.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.85),
                fontSize: 16,
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, delay: 600.ms, duration: 600.ms),

            const SizedBox(height: 48),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
