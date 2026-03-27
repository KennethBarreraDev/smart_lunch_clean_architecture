import 'package:smart_lunch/blocs/sales/sales_state.dart';
import 'package:smart_lunch/core/utils/date_utils.dart';

class SaleUtils {
  static String formatFolio(String? saleId) {
    if (saleId == null) return "";
    return saleId.length > 13
        ? saleId.substring(saleId.length - 13, saleId.length - 1)
        : saleId;
  }

  static String formatDeliveryDate(SaleSuccessState state) {
    final date = state.saleDate ?? DateTime.now();

    if (state.isPresale) {
      return CustomDateUtils.formatDateForPresale(date);
    }

    if ((state.scheduledHour ?? "").isNotEmpty) {
      return CustomDateUtils.formatDateWithMinutes(date);
    }

    return CustomDateUtils.formatDateWithOutMinutes(date);
  }
}
