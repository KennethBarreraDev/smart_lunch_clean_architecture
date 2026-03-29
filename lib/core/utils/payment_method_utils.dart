import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';

class PaymentMethodUtils {
  static String getMethodName(AllowedTopupMethods method) {
    switch (method) {
      case AllowedTopupMethods.openpay:
        return "Openpay";

      case AllowedTopupMethods.mercadoPago:
        return "Mercado Pago";

      case AllowedTopupMethods.croem:
        return "CROEM";

      case AllowedTopupMethods.yappi:
        return "Yappi";
    }
  }
}