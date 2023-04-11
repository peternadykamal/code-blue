import 'package:gradproject/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';

Future<void> testThis() async {
  // Test upload image to firebase storage
  XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
  final url =
      await StorageService().uploadImageToFirebaseStorage("test", image!);
  print(url);
  // test to download image from firebase storage
  final loadedImage =
      await StorageService().downloadImageFromFirebaseStorage(url!);
  print(loadedImage?.path);
  print(loadedImage?.length());
  print(loadedImage?.name);
  print(loadedImage?.runtimeType);
}
