import 'package:cloud_firestore/cloud_firestore.dart';

class SaveAddressFirebase {
  final FirebaseFirestore _firestore;

  SaveAddressFirebase({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveAddress({
    required String userId,
    required String savedAddress,
    required double lat,
    required double lng,
  }) async {
    try {
      await _firestore.collection('places').add({
        'userId': userId,
        'savedaddress': savedAddress,
        'lat': lat,
        'lng': lng,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to save address: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAddresses(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('places')
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Failed to get addresses: $e');
    }
  }

  Future<void> updateAddress({
    required String addressId,
    String? savedAddress,
    double? lat,
    double? lng,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (savedAddress != null) updates['savedaddress'] = savedAddress;
      if (lat != null) updates['lat'] = lat;
      if (lng != null) updates['lng'] = lng;

      await _firestore.collection('places').doc(addressId).update(updates);
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _firestore.collection('places').doc(addressId).delete();
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }
}
