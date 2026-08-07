class AppRoutes {
  static String authRoute = "/login";
  static String resetPasswordRoute = "/reset-password";
  static String checkEmailRoute = "/check-email";
  static String homeRoute = "/home";
  static String splashScreenRoute = "/splash";
  static String termsAndConditionsRoute = "/terms-and-conditions";
  static String privacyPolicyRoute = "/privacy-policy";
  static String saleRoute = "/sale";
  static String multiSaleRoute = "/multi-sale";
  static String summarySale = "/summary-sale";
  static String registerCroemCard = "/register-croem-card";
  static String registerOpenpayCard = "/register-openpay-card";
  static String selectCardToPay = "/select-card-to-pay";
  static String successfulSale = "/successful-sale";
  static String successfulPresale = "/successful-presale";
  static String topupPage = "/topup-page";
  static String panamaCardsSelector = "/panama-cards-selector";
  static String topupStatus = "/topup-status";
  static String membershipsDebtors = "/memberships-debtors";
  static String membershipStatus = "/membership-status";
  static String multisalePage = "/multisale-page";
  static String multisaleCalendar = "/multisale-calendar";
  static String multisaleProducts = "/multisale-products";
  static String multipleSaleSuccessPage = "/multiple-sale-success-page";

  static String children = "/children";
  static String getChild = "/child";

  static String productRestriction = "/product-restriction";
  static String productLimited = "/product-limited";

  static String historyPage= "/history";

  static String settingsPage= "/settings";

  static String userInformation = "/user-information";
  static String paymentInformation = "/payment-information";


  static getCleanRouteName(String route) {
    return route.replaceAll("/", "");
  }
}
