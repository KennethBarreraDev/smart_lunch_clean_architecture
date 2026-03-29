import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/topup/topup_bloc.dart';

import 'package:smart_lunch/blocs/topup/topup_event.dart';
import 'package:smart_lunch/blocs/topup/topup_state.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/core/utils/cafeteria_constants.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class TopupAmountSelector extends StatelessWidget {
  TopupAmountSelector({
    super.key,
    required this.topupState,
    required this.isPanama,
    required this.rechargeTotalInput,
  });
  TopupState topupState;
  bool isPanama;
  TextEditingController rechargeTotalInput;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.suggested_options,
              style: TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 120,
              child: GridView.builder(
                padding: EdgeInsets.zero, // set padding to zero
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  return _valueButton(
                    context,

                    index,
                    topupState.minimunRechargeAmount +
                        (isPanama
                                ? CafeteriaConstants.panamaRechargeFactor
                                : CafeteriaConstants.mexicoRechargeFactor) *
                            (index),
                    topupState,
                  );
                },
              ),
            ),
            Divider(color: AppColors.darkBlue.withValues(alpha: 0.4)),
            !topupState.setTopupFromInput
                ? Center(
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: TextButton(
                        child: Text(
                          AppLocalizations.of(context)!.another_amount,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.orange,
                          ),
                        ),
                        onPressed: () {
                          context.read<TopupBloc>().add(
                            ChangeSetTopupFromInputEvent(
                              setTopupFromInput: true,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.another_amount,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.orange,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20, right: 20),
                            child: const Text(
                              "\$",
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Comfortaa",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 55.w,
                            child: TextField(
                              controller: rechargeTotalInput,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              margin: const EdgeInsets.only(top: 20, left: 15),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                      AppImages.confirmRechargeAmountIcon,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              if (rechargeTotalInput.text.isEmpty ||
                                  rechargeTotalInput.text == "." ||
                                  rechargeTotalInput.text == "-" ||
                                  double.parse(rechargeTotalInput.text) <
                                      topupState.minimunRechargeAmount) {
                                context.read<TopupBloc>().add(
                                  ChangeInsertedAmountErrorEvent(
                                    insertedAmountError: true,
                                  ),
                                );
                              } else {
                                context.read<TopupBloc>().add(
                                  ChangeRechargeAmountEvent(
                                    selectedRechargeAmount: double.parse(
                                      rechargeTotalInput.text,
                                    ),
                                  ),
                                );
                                context.read<TopupBloc>().add(
                                  ChangeInsertedAmountErrorEvent(
                                    insertedAmountError: false,
                                  ),
                                );

                                context.read<TopupBloc>().add(
                                  ChangeSelectedButtonIndexEvent(
                                    selectedButtonIndex: -1,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      Container(
                        margin: const EdgeInsets.only(left: 5, top: 20),
                        child: Text(
                          "*${AppLocalizations.of(context)!.minimum_recharge_amount} ${topupState.minimunRechargeAmount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: AppColors.darkBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                      topupState.insertedAmountError
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: AppColors.coral.withValues(alpha: 0.2),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.amount_not_valid,
                                    style: TextStyle(
                                      fontFamily: "comfortaa",
                                      fontSize: 13,
                                      color: AppColors.coral,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      TextButton(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.cancel_button,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.coral,
                            ),
                          ),
                        ),
                        onPressed: () {
                          context.read<TopupBloc>().add(
                            ChangeRechargeAmountEvent(
                              selectedRechargeAmount:
                                  topupState.minimunRechargeAmount,
                            ),
                          );
                          context.read<TopupBloc>().add(
                            ChangeInsertedAmountErrorEvent(
                              insertedAmountError: false,
                            ),
                          );

                          context.read<TopupBloc>().add(
                            ChangeSetTopupFromInputEvent(
                              setTopupFromInput: false,
                            ),
                          );
                          context.read<TopupBloc>().add(
                            ChangeSelectedButtonIndexEvent(
                              selectedButtonIndex: 0,
                            ),
                          );
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 10)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _valueButton(
    BuildContext context,
    int buttonId,
    double value,
    TopupState topupState,
  ) {
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black38),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: topupState.selectedButtonIndex == buttonId
                ?  BorderSide(color: AppColors.orange)
                : BorderSide(color: AppColors.darkBlue.withValues(alpha: 0.3)),
          ),
        ),
      ),
      onPressed: () {
        rechargeTotalInput.clear();
        context.read<TopupBloc>().add(
          ChangeSelectedButtonIndexEvent(selectedButtonIndex: buttonId),
        );

        context.read<TopupBloc>().add(
          ChangeRechargeAmountEvent(selectedRechargeAmount: value),
        );

        context.read<TopupBloc>().add(
          ChangeInsertedAmountErrorEvent(insertedAmountError: false),
        );
      },
      child: Text(
        "\$$value",
        style: TextStyle(
          fontSize: 15.sp,
          color: topupState.selectedButtonIndex == buttonId
              ? const Color(0xffFFA66A)
              : Colors.black,
        ),
      ),
    );
  }
}
