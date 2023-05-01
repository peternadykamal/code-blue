import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  Future<String?> uploadImageToFirebaseStorage(
      String folderName, XFile imageFile) async {
    try {
      final File file = File(imageFile.path);
      if (!file.existsSync()) {
        throw Exception('File does not exist.');
      }
      final Reference reference =
          _firebaseStorage.ref().child(folderName).child(user!.uid);
      final UploadTask uploadTask = reference.putFile(file);
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      return null;
    }
  }

  Future<Image?> downloadImageFromFirebaseStorage(String imageUrl) async {
    try {
      final Reference reference = _firebaseStorage.refFromURL(imageUrl);
      final data = await reference.getData();
      if (data == null) {
        return null;
      }
      return Image.memory(data);
    } on FirebaseException catch (error) {
      print('Error downloading image from Firebase Storage: $error');
      return null;
    }
  }
}
