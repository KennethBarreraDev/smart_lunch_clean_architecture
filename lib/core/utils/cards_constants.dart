
class CardsConstants {
  static String onCardNumberChange(String cardNumber) {
    String cardBrand = "";
    switch (cardNumber) {
      case "2":
      case "5":
        cardBrand = "mastercard";

      case "4":
        cardBrand = "visa";

      case "3":
        cardBrand = "american_express";
    }
    return cardBrand;
  }
}
