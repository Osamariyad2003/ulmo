import 'package:hive/hive.dart';
import 'credit_card.dart';

class CreditCardAdapter extends TypeAdapter<CreditCard> {
  @override
  final int typeId = 0; // Make sure this ID is unique across your Hive adapters

  @override
  CreditCard read(BinaryReader reader) {
    return CreditCard(
      id: reader.readString(),
      cardNumber: reader.readString(),
      expiryDate: reader.readString(),
      cvv: reader.readString(),
      cardHolderName: reader.readString(),
      cardType: reader.readString(),
      isDefault: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, CreditCard obj) {
    writer.writeString(obj.id ?? '');
    writer.writeString(obj.cardNumber);
    writer.writeString(obj.expiryDate);
    writer.writeString(obj.cvv);
    writer.writeString(obj.cardHolderName);
    writer.writeString(obj.cardType ?? '');
    writer.writeBool(obj.isDefault);
  }
}
