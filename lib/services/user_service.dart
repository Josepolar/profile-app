import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:profile_app/models/user_model.dart';
import 'package:profile_app/utils/constants.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirestorePaths.usersCollection);

  Future<void> createUserDocument({
    required String uid,
    required String email,
    String fullName = '',
    String username = '',
  }) async {
    final user = UserModel(
      uid: uid,
      email: email,
      fullName: fullName,
      username: username,
      createdAt: DateTime.now(),
    );

    await _users.doc(uid).set({
      ...user.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<UserModel?> streamUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserModel.fromFirestore(doc);
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return UserModel.fromFirestore(doc);
  }

  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.uid).update({
      'fullName': user.fullName,
      'username': user.username,
      'email': user.email,
      'bio': user.bio,
      'phone': user.phone,
      'photoUrl': user.photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
