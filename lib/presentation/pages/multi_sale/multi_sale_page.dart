import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_lunch/blocs/multiple_sale/multiple_sale_bloc.dart';
import 'package:smart_lunch/blocs/multiple_sale/multiple_sale_event.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/go_back_button.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/multi_sale/widgets/multisale_children_info.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class MultiSalePage extends StatelessWidget {
  const MultiSalePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 100.h),
            width: 100.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.coral, AppColors.orange],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: GoBackButton(
                    title: AppLocalizations.of(context)!.multisale,
                  ),
                ),

                BlocBuilder<UsersBloc, UsersState>(
                  builder: (context, usersState) {
                    if (usersState is! UsersLoaded) {
                      return SizedBox.shrink();
                    }
                    return Expanded(
                      child: ListView(
                        shrinkWrap: false,
                        padding: EdgeInsets.zero,
                        children: (usersState.children)
                            .map(
                              (child) => MultisaleChildComponent(
                                imageUrl: child.user?.picture ?? "",
                                childName:
                                    "${child.user?.firstName ?? ""} ${child.user?.lastName ?? ""}",
                                dailySpendLimit: child.dailyLimit ?? 0.0,
                                allergies: [], //TODO: Add allergies
                                onTap: () {
                                  context.read<MultipleSaleBloc>().add(
                                    ResetMultiplesaleValue(),
                                  );

                                  context.read<MultipleSaleBloc>().add(
                                    ChangeSelectedUserForMultisale(child),
                                  );

                                  context.read<MultipleSaleBloc>().add(
                                    SetMultiplesaleAvailableDays(),
                                  );

                                  context.pushNamed(
                                    AppRoutes.getCleanRouteName(
                                      AppRoutes.multisaleCalendar,
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension on int {
  double? get w => null;
}
