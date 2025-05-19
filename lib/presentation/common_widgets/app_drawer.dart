import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_store_app/core/utils/extensions.dart';
import 'package:medical_store_app/presentation/common_widgets/gap.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../logic/auth/auth_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Drawer(
          child: Column(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: AppColors.primary.withAlpha(100)),
                child: Column(
                  children: [
                    const Gap(kToolbarHeight),
                    CircleAvatar(
                      minRadius: 40,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        state.user?.username[0].toUpperCase() ?? 'G',
                        style:
                            TextStyles.heading3.copyWith(color: Colors.white),
                      ),
                    ),
                    const Gap(16),
                    Text(
                      state.user?.username.capitalize ?? 'Guest',
                      style: TextStyles.heading2,
                    ),
                    Text(
                      state.user?.isAdmin == true
                          ? '(Admin User)'
                          : '(Regular User)',
                      style: TextStyles.bodyMedium,
                    ),
                    const Gap(16),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  Navigator.pop(context); // Close the drawer
                },
                icon: Icon(Icons.logout),
                label: Text('Logout'),
              ),
              const SizedBox(height: kToolbarHeight),
            ],
          ),
        );
      },
    );
  }
}
