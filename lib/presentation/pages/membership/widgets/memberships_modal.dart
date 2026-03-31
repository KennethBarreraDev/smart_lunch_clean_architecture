import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_lunch/blocs/memberships/memberships_bloc.dart';
import 'package:smart_lunch/blocs/memberships/memberships_event.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/blocs/users/user_event.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/core/base_widgets/modals/modal_action_button.dart';
import 'package:smart_lunch/core/constants/user_roles.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class PendingMembershipModal extends StatelessWidget {
  PendingMembershipModal({super.key, required this.membershipDebtors});
  List<CafeteriaUser> membershipDebtors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, sessionState) {
        if (sessionState is! SessionAuthenticated) {
          return SizedBox.shrink();
        }

        bool isStudent = sessionState.sessionData?.userType == UserRole.student;

        return AlertDialog(
          backgroundColor: AppColors.white,
          scrollable: true,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 5),
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.center,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          titlePadding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          titleTextStyle: TextStyle(
            fontFamily: "Comfortaa",
            color: AppColors.darkBlue,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.pending_membership,
                style: const TextStyle(fontFamily: "Comfortaa"),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 30),
                color: AppColors.darkBlue,
                onPressed: () {
                  context.read<UsersBloc>().add(
                    ToggleMembershipDebtorsModalVisibillity(show: false),
                  );
                },
              ),
            ],
          ),
          content: Container(
            color: AppColors.white,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30, top: 30),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(AppImages.membershipDebt),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Text(
                          "${AppLocalizations.of(context)!.pending_membership_payment}  ${isStudent ? AppLocalizations.of(context)!.payment_by_guardian : ''}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "Comfortaa",
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                if (isStudent)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ModalActionButton(
                        backgroundColor: AppColors.orange,
                        primaryColor: AppColors.orange,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        onTap: () {
                          context.read<MembershipsBloc>().add(
                            FillInitialMemberships(membershipDebtors),
                          );

                          context.pushNamed(
                            AppRoutes.getCleanRouteName(
                              AppRoutes.membershipsDebtors,
                            ),
                          
                          );
                        },
                        text: AppLocalizations.of(context)!.pay_now,
                        textFontSize: 20,
                        textFontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
