import 'package:intl/intl.dart';

class CustomDateUtils {
  static String formatDateForPresale(DateTime date) {
    return DateFormat("EEEE',' d 'de' MMMM  'de' y", 'es').format(date);
  }
}
