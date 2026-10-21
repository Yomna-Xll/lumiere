class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://accessories-eshop.runasp.net/api/';

  static const String register = 'auth/register';
  static const String verifyEmail = 'auth/verify-email';
  static const String resendOtp = 'auth/resend-otp';
  static const String login = 'auth/login';
  static const String refreshToken = 'auth/refresh-token';
  static const String forgotPassword = 'auth/forgot-password';
  static const String validateOtp = 'auth/validate-otp';
  static const String resetPassword = 'auth/reset-password';
  static const String changePassword = 'auth/change-password';
  static const String logout = 'auth/logout';
  static const String me = 'auth/me';

  static const String products = 'products';
  static const String categories = 'categories';

  static const List<String> publicAuthPaths = [
    register,
    verifyEmail,
    resendOtp,
    login,
    refreshToken,
    forgotPassword,
    validateOtp,
    resetPassword,
  ];
}