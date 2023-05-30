import 'package:flutter/material.dart';
import 'package:gradproject/services/settings_service.dart';
import 'package:gradproject/services/storage_service.dart';
import 'package:gradproject/style.dart';
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
  // print(loadedImage?.path); print(loadedImage?.length());
  // print(loadedImage?.name);
  print(loadedImage?.runtimeType);
  List<String> _phoneNumbers = await SettingsService.getAllPhoneNumbers();
  ListView.builder(
    shrinkWrap: true,
    itemCount: _phoneNumbers.length,
    itemBuilder: (context, index) {
      final phoneNumber = _phoneNumbers[index];
      return Container(
        padding: EdgeInsets.only(left: 10),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 4, top: 4),
        decoration: BoxDecoration(
            color: Mycolors.numpad, borderRadius: BorderRadius.circular(10)),
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 40.0, left: 10),
              child: Text(
                phoneNumber,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Mycolors.textcolor,
                  fontSize: 17,
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.remove_circle),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            "Are you sure you want to remove this caregiver?"),
                        actions: [
                          TextButton(
                            child: Text("Cancel",
                                style: TextStyle(color: Mycolors.textcolor)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Mycolors.buttoncolor)),
                            child: Text("Remove"),
                            onPressed: () async {
                              await SettingsService
                                  .removeNonCaregiversPhoneNumbers(phoneNumber);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
      );
      ;
    },
  );
}
