class AppRoutes {
  static String authRoute = "/login";
  static String homeRoute = "/home";
  static String splashScreenRoute = "/splash";
  static String termsAndConditionsRoute = "/terms-and-conditions";
  static String privacyPolicyRoute = "/privacy-policy";
  static String saleRoute = "/sale";


  static getCleanRouteName(String route) {
    return route.replaceAll("/", "");
  }
}
