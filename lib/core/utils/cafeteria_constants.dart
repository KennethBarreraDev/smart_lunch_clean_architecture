import 'package:smart_lunch/core/constants/countries.dart';
import 'package:smart_lunch/core/utils/commission_types.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/data/models/topup_settings.dart';

class CafeteriaConstants {
  static double minimunMexicoBalance = 50;
  static double minimunPanamaBalance = 2;
  static double panamaRechargeFactor = 10;
  static double mexicoRechargeFactor = 100;
  static String defaultCurrency = "MXN";
  static String defaultCardBrand = "visa";
  static double croemFee = 3.5;
  static double yappyFee = 2;
  static double panamaMembershipPrice = 1.20;

  static TopupSettings getTopupSetting(
    CafeteriaSetting settings,
    Cafeteria cafeteria,
  ) {
    bool isPanama = Countries.isPanama(cafeteria.school?.country ?? "");

    double minimunRechargeAmount = isPanama ? 5 : 50;
    bool chargeCommissionToParent = settings.chargeCommissionToParents;
    double commissionFee = 0.0;
    CommissionTypes commissionType = CommissionTypes.fee;
    double selectedRechargeAmount = 0.0;

    if (settings.openpayRecharge) {
      minimunRechargeAmount = settings.minimunOpenPayRechargeValue.toDouble();
    }

    if (!settings.openpayRecharge && settings.minimumRechargeEnabled) {
      minimunRechargeAmount = settings.minimumRechargeAmount.toDouble();
    }

    if (!settings.openpayRecharge && settings.minimumRechargeNoCommission) {
      minimunRechargeAmount = settings.minimumRechargeNoCommissionAmount
          .toDouble();
    }

    if (chargeCommissionToParent) {
      commissionFee = settings.chargeCommissionToParentsAmount;
    }

    selectedRechargeAmount = minimunRechargeAmount;

    return TopupSettings(
      minimunRechargeAmount: minimunRechargeAmount,
      selectedRechargeAmount: selectedRechargeAmount,
      commissionFee: commissionFee,
      chargeCommissionToParent: chargeCommissionToParent,
      commissionType: commissionType,
    );
  }
}
