// import 'package:flutter/material.dart';
// import 'package:lumiere/core/theme/app_colors.dart';
// import 'package:lumiere/core/widgets/app_logo.dart';
// import 'package:lumiere/core/widgets/auth_button.dart';
// import 'package:lumiere/core/widgets/auth_footer_link.dart';
// import 'package:lumiere/core/widgets/auth_header.dart';
// import 'package:lumiere/core/widgets/auth_scaffold.dart';
// import 'package:lumiere/core/widgets/custom_text_field.dart';
// import 'package:lumiere/core/widgets/google_button.dart';
// import 'package:lumiere/core/widgets/or_divider.dart';
// import 'package:lumiere/core/widgets/otp_boxes.dart';
// import 'package:lumiere/core/widgets/password_text_field.dart';
// import 'package:lumiere/core/widgets/resend_timer.dart';
// import 'package:lumiere/core/widgets/snack_bar.dart';

// class AuthTestScreen extends StatefulWidget {
//   const AuthTestScreen({super.key});

//   @override
//   State<AuthTestScreen> createState() => _AuthTestScreenState();
// }

// class _AuthTestScreenState extends State<AuthTestScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _hasOtpError = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AuthScaffold(
//       showBackButton: true,
//       onBackTap: () => debugPrint('Back button tapped'),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const Center(child: AppLogo(width: 48, height: 48)),
//           const SizedBox(height: 24),
//           const AuthHeader(
//             title: 'Welcome back',
//             subtitle: 'Sign in to access your curated collection',
//           ),
//           const SizedBox(height: 32),
//           CustomTextField(
//             controller: _emailController,
//             labelText: 'Email Address',
//             hintText: 'name@example.com',
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 16),
//           PasswordTextField(
//             controller: _passwordController,
//             labelText: 'Password',
//             helperText: 'At least 1 uppercase letter and 1 special character',
//           ),
//           const SizedBox(height: 24),
//           AuthButton(
//             text: 'Login',
//             isLoading: _isLoading,
//             onPressed: () {
//               setState(() => _isLoading = true);
//               Future.delayed(const Duration(seconds: 2), () {
//                 if (!mounted) return;
//                 setState(() => _isLoading = false);
//                 AppSnackBar.show(context, 'Logged in successfully');
//               });
//             },
//           ),
//           const SizedBox(height: 24),
//           const OrDivider(),
//           const SizedBox(height: 16),
//           GoogleButton(onPressed: () => debugPrint('Google tapped')),
//           const SizedBox(height: 32),
//           const Text(
//             'Verify Code Test (correct code: 123456)',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 12),
//           OtpBoxes(
//             hasError: _hasOtpError,
//             onChanged: (code) {
//               setState(() {
//                 _hasOtpError = code.length == 6 && code != '123456';
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           ResendTimer(
//             seconds: 30,
//             onResend: () => debugPrint('Resend triggered'),
//           ),
//           const SizedBox(height: 32),
//           AuthFooterLink(
//             normalText: "Don't have an account?",
//             actionText: 'Sign up',
//             onTap: () {
//               AppSnackBar.show(context, 'Something went wrong', isError: true);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
