import 'package:cloud_firestore/cloud_firestore.dart';
import '../data_source/save_address_firebase.dart';
import '../model/delivery_model.dart';

class DeliveryRepository {
  final SaveAddressFirebase _addressDataSource;

  DeliveryRepository({required SaveAddressFirebase addressDataSource})
    : _addressDataSource = addressDataSource;

  Future<void> saveDeliveryInfo(DeliveryInfo info) async {
    await _addressDataSource.saveAddress(
      userId: info.userId,
      savedAddress: info.address,
      lat: info.lat,
      lng: info.lng,
    );
  }

  Future<List<DeliveryInfo>> getSavedAddresses(String userId) async {
    final addresses = await _addressDataSource.getAddresses(userId);
    return addresses
        .map(
          (address) => DeliveryInfo.fromMap(address, ),
        )
        .toList();
  }

  Future<void> updateDeliveryInfo(DeliveryInfo info) async {
    if (info.userId == null) throw Exception('Address ID is required for update');

    await _addressDataSource.updateAddress(
      addressId: info.userId!,
      savedAddress: info.address,
      lat: info.lat,
      lng: info.lng,
    );
  }

  Future<void> deleteDeliveryInfo(String addressId) async {
    await _addressDataSource.deleteAddress(addressId);
  }

  Future<DeliveryInfo?> getDefaultAddress(String userId) async {
    final addresses = await getSavedAddresses(userId);
    return addresses.isNotEmpty ? addresses.first : null;
  }
}
