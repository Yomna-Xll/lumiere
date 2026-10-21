import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';
import 'package:lumiere/core/widgets/auth/app_logo.dart';
import 'package:lumiere/core/widgets/state_view.dart';
import 'package:lumiere/features/auth/cubit/session_cubit.dart';
import 'package:lumiere/features/auth/cubit/session_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SessionCubit>().check();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        if (state is SessionNetworkError) {
          return Scaffold(
            body: StateView(
              icon: Icons.wifi_off,
              title: 'No internet connection',
              actionText: 'Retry',
              onAction: () => context.read<SessionCubit>().check(),
            ),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppLogo(width: 96, height: 96),
                        SizedBox(height: 16),
                        Text('LUMIÈRE', style: AppTextStyle.wordmark),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 48),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
