import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';

class ResendTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback onResend;

  const ResendTimer({super.key, this.seconds = 45, required this.onResend});

  @override
  State<ResendTimer> createState() => ResendTimerState();
}

class ResendTimerState extends State<ResendTimer> {
  late int remainingSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.seconds;
    startTimer();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final formattedTime =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Didn't receive the code? ", style: AppTextStyle.body),
        remainingSeconds > 0
            ? Text(
                "Resend in $formattedTime",
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textHint,
                ),
              )
            : TextButton(
                onPressed: () {
                  widget.onResend();
                  setState(() {
                    remainingSeconds = widget.seconds;
                  });
                  startTimer();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Resend",
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ],
    );
  }
}
