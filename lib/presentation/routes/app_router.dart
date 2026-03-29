import 'package:go_router/go_router.dart';
import 'package:smart_lunch/core/base_widgets/bank_cards/panama/panama_cards_selector.dart';
import 'package:smart_lunch/presentation/pages/auth/auth_page.dart';
import 'package:smart_lunch/presentation/pages/croem/register_croem_card.dart';
import 'package:smart_lunch/presentation/pages/home/home_page.dart';
import 'package:smart_lunch/presentation/pages/legal_information/privacity.dart';
import 'package:smart_lunch/presentation/pages/legal_information/terms_and_conditions.dart';
import 'package:smart_lunch/presentation/pages/openpay/register_openpay_card.dart';
import 'package:smart_lunch/presentation/pages/sale/sale_page.dart';
import 'package:smart_lunch/presentation/pages/select-card-to-pay/SelectCardToPay.dart';
import 'package:smart_lunch/presentation/pages/splash/splash_page.dart';
import 'package:smart_lunch/presentation/pages/successful_sale/successful_presale_page.dart';
import 'package:smart_lunch/presentation/pages/successful_sale/sucessful_sale_page.dart';
import 'package:smart_lunch/presentation/pages/successful_topup/sucessful_toup_page.dart';
import 'package:smart_lunch/presentation/pages/summary_sale/summary_sale_page.dart';
import 'package:smart_lunch/presentation/pages/top_up/top_up_page.dart';
import 'package:smart_lunch/presentation/routes/routes.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splashScreenRoute,
    routes: [
      GoRoute(
        path: AppRoutes.authRoute,
        name: AppRoutes.getCleanRouteName(AppRoutes.authRoute),
        builder: (context, state) => AuthPage(),
      ),

      GoRoute(
        path: AppRoutes.homeRoute,
        name: AppRoutes.getCleanRouteName(AppRoutes.homeRoute),
        builder: (context, state) => const HomePage(),
      ),

      GoRoute(
        path: AppRoutes.splashScreenRoute,
        name: AppRoutes.getCleanRouteName(AppRoutes.splashScreenRoute),
        builder: (context, state) => const SplashPage(),
      ),

      GoRoute(
        path: AppRoutes.termsAndConditionsRoute,
        name: AppRoutes.getCleanRouteName(AppRoutes.termsAndConditionsRoute),
        builder: (context, state) => const TermsAndConditions(),
      ),

      GoRoute(
        path: AppRoutes.privacyPolicyRoute,
        name: AppRoutes.getCleanRouteName(AppRoutes.privacyPolicyRoute),
        builder: (context, state) => const PrivacityPolicy(),
      ),

      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.saleRoute),
        path: AppRoutes.saleRoute,
        builder: (context, state) {
          final isPresale = state.extra as bool? ?? false;

          return SalePage(isPresale: isPresale);
        },
      ),

      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.registerCroemCard),
        path: AppRoutes.registerCroemCard,
        builder: (context, state) => const RegisterCroemCardPage(),
      ),

      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.registerOpenpayCard),
        path: AppRoutes.registerOpenpayCard,
        builder: (context, state) => RegisterOpenpayCard(),
      ),

      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.successfulSale),
        path: AppRoutes.successfulSale,
        builder: (context, state) => SuccessfulSalePage(),
      ),

      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.selectCardToPay),
        path: AppRoutes.selectCardToPay,
        builder: (context, state) => SelectCardToPayPage(),
      ),

      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.successfulPresale),
        path: AppRoutes.successfulPresale,
        builder: (context, state) => SuccessfulPreSalePage(),
      ),
      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.summarySale),
        path: AppRoutes.summarySale,
        builder: (context, state) => const SummarySalePage(),
      ),

      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.panamaCardsSelector),
        path: AppRoutes.panamaCardsSelector,
        builder: (context, state) => const PanamaCardsSelector(),
      ),

      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.topupPage),
        path: AppRoutes.topupPage,
        builder: (context, state) => TopupPage(),
      ),

      GoRoute(
        name: AppRoutes.getCleanRouteName(AppRoutes.topupStatus),
        path: AppRoutes.topupStatus,
        builder: (context, state) => TopupSuccessPage(),
      ),
    ],
  );
}
