import 'package:intl/intl.dart';

class CustomDateUtils {
  static String formatDateForPresale(DateTime date) {
    return DateFormat("EEEE',' d 'de' MMMM  'de' y", 'es').format(date);
  }

  static String formatDateWithMinutes(DateTime date) {
    return DateFormat(
      "EEEE',' d 'de' MMMM  'de' y',' HH:mm",
      'es',
    ).format(date).toString();
  }

  static String formatDateWithOutMinutes(DateTime date) {
    return DateFormat(
      "EEEE',' d 'de' MMMM  'de' y",
      'es',
    ).format(date).toString();
  }

  static String formatDateWithoutTime(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
