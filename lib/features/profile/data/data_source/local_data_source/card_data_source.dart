import 'package:hive_flutter/hive_flutter.dart';
import 'package:ulmo/features/profile/data/models/credit_card_adapter.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/credit_card.dart';

/// Card storage implementation using Hive local database
class HiveCardStorage {
  late Box<CreditCard> _cardsBox;
  late Box<String> _settingsBox;
  static const String _defaultCardKey = 'default_card_id';

  HiveCardStorage._();

  /// Factory constructor to create and initialize storage
  static Future<HiveCardStorage> create() async {
    final instance = HiveCardStorage._();
    await instance._init();
    return instance;
  }

  /// Initialize the storage with Hive boxes
  Future<void> _init() async {
    if (!Hive.isAdapterRegistered(0)) {
      // Use appropriate adapter ID
      Hive.registerAdapter(CreditCardAdapter());
    }

    await Hive.openBox<CreditCard>('payment_cards');
    await Hive.openBox<String>('payment_settings');

    _cardsBox = Hive.box<CreditCard>('payment_cards');
    _settingsBox = Hive.box<String>('payment_settings');
  }

  /// Get all saved payment cards
  List<CreditCard> getCards() {
    try {
      return _cardsBox.values.toList();
    } catch (e) {
      print("Error getting cards from Hive: $e");
      return [];
    }
  }

  /// Get the default card ID
  String? getDefaultCardId() {
    return _settingsBox.get(_defaultCardKey);
  }

  /// Save a card to storage
  Future<void> saveCard(CreditCard card) async {
    try {
      // Generate ID if not present
      final cardWithId =
          card.id == null ? card.copiedWith(id: const Uuid().v4()) : card;

      // Save card to local storage
      await _cardsBox.put(cardWithId.id!, cardWithId);

      // If this is the first card or marked as default, set as default
      if (card.isDefault || _cardsBox.length == 1) {
        await setDefaultCard(cardWithId.id!);
      }
    } catch (e) {
      print("Error saving card to Hive: $e");
      rethrow;
    }
  }

  /// Delete a card from storage
  Future<void> deleteCard(String cardId) async {
    try {
      await _cardsBox.delete(cardId);

      final defaultCardId = getDefaultCardId();
      if (cardId == defaultCardId && _cardsBox.isNotEmpty) {
        final newDefaultCard = _cardsBox.keys.first.toString();
        await setDefaultCard(newDefaultCard);
      } else if (_cardsBox.isEmpty) {
        await _settingsBox.delete(_defaultCardKey);
      }
    } catch (e) {
      print("Error deleting card from Hive: $e");
      rethrow;
    }
  }

  /// Set a card as the default payment method
  Future<void> setDefaultCard(String cardId) async {
    try {
      await _settingsBox.put(_defaultCardKey, cardId);
    } catch (e) {
      print("Error setting default card in Hive: $e");
      rethrow;
    }
  }
}
