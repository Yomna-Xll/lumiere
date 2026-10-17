import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
 
class AppSnackBar {
  static void show(BuildContext context, String message,
      {bool isError = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? AppColors.gold : Colors.white,
              size: 20,
            ),
             SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        action: SnackBarAction(
          label: '✕',
          textColor: Colors.white,
          onPressed: messenger.hideCurrentSnackBar,
        ),
      ),
    );
  }
}
 