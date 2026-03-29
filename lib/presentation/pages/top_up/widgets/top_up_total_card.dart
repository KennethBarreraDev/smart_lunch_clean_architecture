import 'package:flutter/material.dart';
import 'package:smart_lunch/blocs/topup/topup_state.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/data/models/cafeteria_setting_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class TopUpTotalCard extends StatelessWidget {
   TopUpTotalCard({
    super.key,
    required this.cafeteriaSetting,
    required this.topupState,
    required this.onTopupBalance,
  });

  final CafeteriaSetting cafeteriaSetting;
  final TopupState topupState;
  VoidCallback? onTopupBalance;


  double _parentCommission() {
    return (((((topupState.selectedRechargeAmount + topupState.commissionFee) /
                        0.959516) -
                    topupState.selectedRechargeAmount) *
                100)
            .floor() /
        100);
  }

  double _openpayCommission() {
    return (((((topupState.selectedRechargeAmount + 2.9) / 0.96636) -
                    topupState.selectedRechargeAmount) *
                100)
            .floor() /
        100);
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = topupState.selectedRechargeAmount;

    double totalCharges = 0;

    if (topupState.chargeCommissionToParent) {
      totalCharges += _parentCommission();
    }

    if (cafeteriaSetting.chargeOpenpayRecharge) {
      totalCharges += _openpayCommission();
    }

    final total = subtotal + totalCharges;

    Widget buildRow(String label, double value, {bool isMuted = false}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isMuted
                  ? AppColors.darkBlue.withValues(alpha: 0.5)
                  : AppColors.darkBlue.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.only(
          top: 50,
          right: 20,
          left: 20,
          bottom: 80,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRow(AppLocalizations.of(context)!.subtotal, subtotal),

            if (topupState.chargeCommissionToParent) ...[
              const SizedBox(height: 10),
              buildRow(
                "Cargo por servicio",
                _parentCommission(),
                isMuted: true,
              ),
            ],

            if (cafeteriaSetting.chargeOpenpayRecharge) ...[
              const SizedBox(height: 10),
              buildRow(
                "Cargo por servicio",
                _openpayCommission(),
                isMuted: true,
              ),
            ],

            const SizedBox(height: 15),
            Divider(color: AppColors.darkBlue.withValues(alpha: 0.5)),

            Text(
              AppLocalizations.of(context)!.total_price,
              style: TextStyle(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${total.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 30),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: OutlinedButton(
                    onPressed: onTopupBalance,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.tuitionGreen.withValues(
                        alpha: 0.2,
                      ),
                      side: BorderSide(
                        color: AppColors.tuitionGreen.withValues(alpha: 0.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: topupState.processingTopup
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.credit_score_outlined,
                                color: AppColors.tuitionGreen,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(context)!.confirm_button,
                                style: TextStyle(color: AppColors.tuitionGreen),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
