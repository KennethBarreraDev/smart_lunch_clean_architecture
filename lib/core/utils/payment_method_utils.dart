import 'package:smart_lunch/core/utils/allowed_topup_methods.dart';

class PaymentMethodUtils {
  static String getMethodName(AllowedPaymentMethods method) {
    switch (method) {
      case AllowedPaymentMethods.openpay:
        return "Openpay";

      case AllowedPaymentMethods.mercadoPago:
        return "Mercado Pago";

      case AllowedPaymentMethods.croem:
        return "CROEM";

      case AllowedPaymentMethods.yappi:
        return "Yappi";
    }
  }
}