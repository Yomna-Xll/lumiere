import 'package:intl/intl.dart';

class Formatters {
  Formatters._(); 

  static const String currencySymbol = r'$';
  static final NumberFormat _number = NumberFormat('#,##0.##');

  static String number(double value) => _number.format(value);

  static String price(double value) => '$currencySymbol${_number.format(value)}';

  static String capitalize(String text) =>
      text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}