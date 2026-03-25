class ApiUrls {
  static String baseUrl = "https://backend2-dev.smartschool.mx/api";

  //Auth
  static String loginUrl = "$baseUrl/token/";
  static String refreshTokenUrl = "$baseUrl/token/refresh/";

  //Cafeteria
  static String cafeteriaUrl = "$baseUrl/smartlunch/cafeteria/";
  static String cafeteriaSettingsUrl =
      "$baseUrl/smartlunch/cafeteria-settings/";

  //App version
  static String appVersionUrl = "$baseUrl/core/app_version/";

  //Users
  static String cafeteriaUserUrl = "$baseUrl/smartlunch/cafeteria-user/";

  //Family
  static String familyUrl = "$baseUrl/core/family/";

  //Sales
  static String salesUrl = "$baseUrl/smartlunch/sale/";

  //Products
  static String categoriesUrl = "$baseUrl/smartlunch/category/";
  static String productsUrl = "$baseUrl/smartlunch/product/";

  //Openpay
  static String openpayCustomer = "$baseUrl/smartlunch/open-pay/customer/";
  static String openPayCredentialsUrl =
      "$baseUrl/smartlunch/open-pay/credentials/";
  static String openPayTutorUrl = "$baseUrl/smartlunch/open-pay/customer/";

  //Recharges
  static String rechargeUrl = "$baseUrl/smartlunch/recharge/";
}
