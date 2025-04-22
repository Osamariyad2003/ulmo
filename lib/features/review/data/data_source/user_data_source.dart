import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/models/user.dart';

class UserDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> getUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return User.fromMap( doc.data()!);
  }
}
