import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/openpay/openpay_bloc.dart';
import 'package:smart_lunch/blocs/openpay/openpay_event.dart';
import 'package:smart_lunch/blocs/openpay/openpay_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/loader/main_loader.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/providers/openpay_provider.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/openpay/credit_cards_row.dart';
import 'package:smart_lunch/presentation/pages/openpay/debit_cards_row.dart';
import 'package:smart_lunch/presentation/pages/openpay/expiration_date_field.dart';

class RegisterOpenpayCard extends StatelessWidget {
  RegisterOpenpayCard({super.key});

  TextEditingController holderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expirationMonthController = TextEditingController();
  TextEditingController expirationYearController = TextEditingController();
  TextEditingController cvv2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenpayBloc, OpenpayState>(
      builder: (context, openpayState) {
        if (openpayState is OpenpayLoading) {
          return MainLoader();
        }

        // if (openpayState is! OpenpayLoaded &&
        //     openpayState is! OpenpayCardsLoaded &&
        //     openpayState is! RegisteringOpenpayCard) {
        //   return const SizedBox.shrink();
        // }

        return TransparentScaffold(
          selectedOption: "Colegiaturas",
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAppBar(
                height: 20.h,
                showPageTitle: true,
                pageTitle: AppLocalizations.of(context)!.register_card,
                image: AppImages.appBarShortImg,
                showDrawer: false,
              ),
              const SizedBox(height: 9),
              Expanded(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  child: TextFormField(
                                    controller: holderNameController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(
                                        context,
                                      )!.owner_full_name,
                                      border: const OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.name,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: TextFormField(
                                        maxLength: 16,
                                        enabled: true,
                                        onChanged: (value) {
                                          onChanged:
                                          (value) {
                                            Openpay? openpay;

                                            if (openpayState
                                                is OpenpayCardsLoaded) {
                                              context.read<OpenpayBloc>().add(
                                                ChangeOpenpayCardBrandEvent(
                                                  value,
                                                  openpayState.openpay,
                                                  openpayState.selectedCard,
                                                  openpayState.cards ?? [],
                                                  ""
                                                ),
                                              );
                                            }
                                          };
                                        },
                                        controller: cardNumberController,
                                        decoration: InputDecoration(
                                          labelText: AppLocalizations.of(
                                            context,
                                          )!.card_number,
                                          border: const OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    const Spacer(),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 65,
                                        maxHeight: 41,
                                      ),
                                      child: openpayState is OpenpayCardsLoaded
                                          ? Image.asset(
                                              AppImages.getCardBrandImage(
                                                openpayState.cardBrand,
                                              ),
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: ExpirationDateField(
                                        expirationMonthController:
                                            expirationMonthController,
                                        expirationYearController:
                                            expirationYearController,
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: TextFormField(
                                          enabled: true,
                                          controller: cvv2Controller,
                                          decoration: const InputDecoration(
                                            labelText: "CVV",
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(4),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.tuitionGreen
                                        .withValues(alpha: 0.15),
                                    shadowColor: Colors.transparent,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (openpayState is OpenpayCardsLoaded) {
                                      context.read<OpenpayBloc>().add(
                                        RegisterOpenpayCardEvent(
                                          openpayState.openpay,
                                          holderNameController.text,
                                          cardNumberController.text,
                                          cvv2Controller.text,
                                          expirationMonthController.text,
                                          expirationYearController.text,
                                          (openpayState.cards ?? []).length + 1,
                                          openpayState
                                                  .openpay
                                                  ?.deviceSessionId ??
                                              "",
                                          openpayState.cards ?? [],
                                        ),
                                      );
                                    }
                                  },
                                  child: openpayState is OpenpayLoading
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_card,
                                              color: AppColors.tuitionGreen,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.register_button,

                                              style: TextStyle(
                                                color: AppColors.tuitionGreen,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: AppColors.tuitionGreen,
                                            ),
                                          ],
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(
                              color: AppColors.lightBlue.withValues(alpha: 0.1),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Transacciones realizadas vía",
                              style: TextStyle(
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 112,
                                maxHeight: 32,
                              ),
                              child: Image.asset(AppImages.openpayColor),
                            ),
                            const SizedBox(height: 10),
                            const CreditCardRow(),
                            const DebitCardsRow(),
                            const Divider(),
                            const SizedBox(height: 23),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.support_agent,
                                  color: Color(0xFF346DBE),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.support_message,
                                  style: const TextStyle(
                                    color: Color(0xff346dbe),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "contacto@smartschool.mx",
                              style: TextStyle(
                                color: Color(0xff346dbe),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
