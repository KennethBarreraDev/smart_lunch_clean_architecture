
import 'package:smart_lunch/data/models/generic_card.dart';

class CroemCard  extends GenericCard{
  final int? id;
  final String? tokenizedCard;
  final int? user;
  final String? cardNumber;
  final String? cardHolderName;
  final String? identifierName;
  final String? createdAt;
   final int internalId;


  // CardInfo(
  //   this.cardNumber,
  //   this.holderName,
  //   this.expirationYear,
  //   this.expirationMonth,
  //   String this.cvv2,
  // )   : brand = null,
  //       creationDate = null;

  CroemCard({
    required this.id,
    required this.user,
    required this.cardHolderName,
    required this.cardNumber,
    required this.identifierName,
    required this.tokenizedCard,
    required this.createdAt,
    this.internalId=-1
  });

  factory CroemCard.fromBackend(Map data, int internalId) {
    return CroemCard(
      id: data["id"],
      user: data["user"],
      tokenizedCard: data["tokenized_card"],
      cardNumber: data["card_number"],
      cardHolderName: data["card_holder_name"],
      identifierName: data["identifier_name"],
      createdAt: data["created_at"],
    );
  }

  @override
  String toString() {
    return 'CroemCardInfo(id: $id, tokenizedCard: $tokenizedCard, user: $user, cardNumber: $cardNumber, cardHolderName: $cardHolderName, identifierName: $identifierName, createdAt: $createdAt)';
  }
}
