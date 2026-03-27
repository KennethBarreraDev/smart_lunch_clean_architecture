
import 'package:smart_lunch/data/models/generic_card.dart';

class OpenpayCard extends GenericCard{
  final String cardNumber;
  final String holderName;
  final String expirationYear;
  final String expirationMonth;
  final String? cvv2;
  final String? brand;
  final String? creationDate;
  final String? id;
  final int internalId;

  // CardInfo(
  //   this.cardNumber,
  //   this.holderName,
  //   this.expirationYear,
  //   this.expirationMonth,
  //   String this.cvv2,
  // )   : brand = null,
  //       creationDate = null;

  OpenpayCard({
    required this.cardNumber,
    required this.holderName,
    required this.expirationYear,
    required this.expirationMonth,
    this.id,
    this.cvv2,
    this.brand,
    this.creationDate,
    this.internalId = -1,
  });

  factory OpenpayCard.fromBackend(Map data, int internalId) {
    return OpenpayCard(
      id: data["id"],
      brand: data['brand'] ?? "",
      cardNumber:
          data['card_number']?.substring(data['card_number'].length - 4) ?? "",
      holderName: data['holder_name'] ?? "",
      expirationYear: data['expiration_year'] ?? "",
      expirationMonth: data['expiration_month'] ?? "",
      creationDate: data['creationDate'] ?? "",
      cvv2: data['cvv2'] ?? "",
      internalId: internalId,
    );
  }

  @override
  String toString() {
    return 'CardInfo{cardNumber: ${cardNumber.contains('XX') ? cardNumber : 'hidden'}, holderName: $holderName, expirationYear: $expirationYear, expirationMonth: $expirationMonth, cvv2: ${cvv2 == null ? null : '***'}, brand: $brand, creationDate: $creationDate, id: $id, internalId: $internalId}';
  }
}
