import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/theme/app_text_style.dart';

class ResendTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback onResend;

  const ResendTimer({
    super.key,
    this.seconds = 45,
    required this.onResend,
  });

  @override
  State<ResendTimer> createState() => _ResendTimerState();
}

class _ResendTimerState extends State<ResendTimer> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _remainingSeconds = widget.seconds;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive code? ",
          style: AppTextStyle.body,
        ),
        _remainingSeconds > 0
            ? Text(
                "Resend in 00:${_remainingSeconds.toString().padLeft(2, '0')}",
                style: AppTextStyle.bodyMedium.copyWith(color: AppColors.textHint),
              )
            : GestureDetector(
                onTap: () {
                  widget.onResend();
                  _startTimer();
                },
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