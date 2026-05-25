import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:profile_app/utils/constants.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadProfileImage({
    required String uid,
    required File imageFile,
  }) async {
    final ref = _storage.ref().child(StoragePaths.profileImage(uid));
    final uploadTask = await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return uploadTask.ref.getDownloadURL();
  }

  Future<void> deleteProfileImage(String uid) async {
    try {
      final ref = _storage.ref().child(StoragePaths.profileImage(uid));
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') {
        rethrow;
      }
    }
  }
}
