class AppRoutes {
  static String authRoute = "/login";
  static String homeRoute = "/home";
  static String splashScreenRoute = "/splash";
  static String termsAndConditionsRoute = "/terms-and-conditions";
  static String privacyPolicyRoute = "/privacy-policy";
  static String saleRoute = "/sale";
  static String summarySale = "/summary-sale";
  static String registerCroemCard = "/register-croem-card";
  static String registerOpenpayCard = "/register-openpay-card";
  static String selectCardToPay = "/select-card-to-pay";


  static getCleanRouteName(String route) {
    return route.replaceAll("/", "");
  }
}
