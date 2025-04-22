import 'package:hive/hive.dart';

import '../../models/credit_card.dart';

class HiveCardStorage {
  static const String _boxName = 'payment_cards';
  late Box<Map> _cardBox;

  HiveCardStorage(this._cardBox);

  static Future<HiveCardStorage> create() async {
    final Box<Map> cardBox = await Hive.openBox<Map>(_boxName);
    return HiveCardStorage(cardBox);
  }

  Future<bool> saveCard(CreditCard card) async {
    try {
      final String cardId = card.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      final cardToSave = CreditCard(
        cardNumber: card.cardNumber,
        expiryDate: card.expiryDate,
        cvv: card.cvv,
        cardHolderName: card.cardHolderName,
        id: cardId,
      );

      // Store card in Hive using ID as key
      await _cardBox.put(cardId, cardToSave.toJson());
      return true;
    } catch (e) {
      print('Error saving card: $e');
      return false;
    }
  }

  List<CreditCard> getCards() {
    try {
      return _cardBox.values
          .map((map) => CreditCard.fromJson(Map<String, dynamic>.from(map)))
          .toList();
    } catch (e) {
      print('Error getting cards: $e');
      return [];
    }
  }

  Future<bool> deleteCard(String cardId) async {
    try {
      await _cardBox.delete(cardId);
      return true;
    } catch (e) {
      print('Error deleting card: $e');
      return false;
    }
  }
}