import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  // Get user data
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collectionPath).doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Add or Update user data
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection(_collectionPath).doc(user.uid).set(user.toMap());
    } catch (e) {
      print(e.toString());
    }
  }
}

