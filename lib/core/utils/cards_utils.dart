class CardsUtils {
  static String getCardBrand(String cardNumber) {
    String cardBrand = cardNumber[0];

    if (cardBrand.isNotEmpty) {
      switch (cardBrand) {
        case "2":
        case "5":
          return "mastercard";

        case "4":
          return "visa";

        case "3":
          return "american_express";

        default:
          return "";
      }
    } else {
      return "";
    }
  }
}
