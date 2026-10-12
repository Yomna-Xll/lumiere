import 'package:flutter/material.dart';
import 'package:lumiere/core/theme/app_colors.dart';
import 'package:lumiere/core/widgets/auth_footer_link.dart';
import 'package:lumiere/core/widgets/auth_header.dart';
import 'package:lumiere/core/widgets/auth_scaffold.dart';
import 'package:lumiere/core/widgets/custom_text_field.dart';
import 'package:lumiere/core/widgets/google_button.dart';
import 'package:lumiere/core/widgets/or_divider.dart';
import 'package:lumiere/core/widgets/otp_boxes.dart';
import 'package:lumiere/core/widgets/password_text_field.dart';
import 'package:lumiere/core/widgets/resend_timer.dart';
// استدعي جميع الملفات التي قمتِ بإنشائها
// import 'auth_scaffold.dart';
// import 'app_logo.dart';
// import 'auth_header.dart';
// import 'custom_text_field.dart';
// import 'password_text_field.dart';
// import 'or_divider.dart';
// import 'google_button.dart';
// import 'auth_footer_link.dart';
// import 'otp_boxes.dart';
// import 'resend_timer.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  // Controllers للاختبار
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // حالة الـ OTP (لتجربة حالة الخطأ أو النجاح)
  bool _hasOtpError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 7. استخدام الهيكل المشترك (AuthScaffold) مع سهم الرجوع
    return AuthScaffold(
      showBackButton: true,
      onBackTap: () {
        print("Back button tapped");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 6. اللوجو (AppLogo)
          const Center(
            child: FlutterLogo(size: 48), // استبدليها بـ AppLogo(width: 48, height: 48)
          ),
          const SizedBox(height: 24),

          // 3. العنوان و الـ Subtitle (AuthHeader)
          const AuthHeader(
            title: "Welcome back",
            subtitle: "Sign in to access your curated collection",
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          const SizedBox(height: 32),

          // الحقول العادية وكلمة المرور (CustomTextField & PasswordTextField)
          CustomTextField(
            controller: _emailController,
            labelText: 'Email Address',
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: '••••••••',
          ),
          const SizedBox(height: 24),

          // زر الدخول وتجربة الـ SnackBar (رقم 8)
          ElevatedButton(
            onPressed: () {
              // تجربة رسالة نجاح
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("تم تسجيل الدخول بنجاح!"),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 24),

          // 4. الفاصل (OrDivider) و زر جوجل (GoogleButton)
          const OrDivider(text: 'OR CONTINUE WITH'),
          const SizedBox(height: 16),
          GoogleButton(
            onPressed: () {
              print("Google button clicked");
            },
          ),
          const SizedBox(height: 32),

          // 9. اختبار خانات الـ OTP (OtpBoxes)
          const Text(
            "Verify Code Test:",
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          OtpBoxes(
            length: 6,
            hasError: _hasOtpError,
            onCompleted: (code) {
              print("Entered OTP Code: $code");
              // يمكنك هنا عكس قيمة الخطأ للتجربة
              setState(() {
                _hasOtpError = code != "123456"; // مثال: لو الكود مش كدا يظهر خطأ
              });
            },
          ),
          const SizedBox(height: 16),

          // 10. العد التنازلي (ResendTimer)
          ResendTimer(
            seconds: 30,
            onResend: () {
              print("Resend code triggered");
            },
          ),
          const SizedBox(height: 32),

          // 5. الـ Footer Link (AuthFooterLink)
          AuthFooterLink(
            normalText: "Don't have an account?",
            actionText: "Sign up",
            onTap: () {
              print("Sign up link clicked");
            },
          ),
        ],
      ),
    );
  }
}