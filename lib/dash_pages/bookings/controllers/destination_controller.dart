import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DestinationController extends GetxController {
  var image1 = Rx<File?>(null);
  var image2 = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> pickImage(int imageNumber) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (imageNumber == 1) {
        image1.value = File(pickedFile.path);
      } else {
        image2.value = File(pickedFile.path);
      }
      update(); // Notify UI to refresh
    }
  }

  Future<String?> _uploadToFirebase(File image, String path) async {
    try {
      final ref = _storage.ref().child("uploads/$path");
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Upload Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  Future<void> submit() async {
    if (image1.value == null || image2.value == null) {
      Get.snackbar('Error', 'Please upload both images before submitting.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.snackbar('Uploading', 'Uploading images, please wait...', snackPosition: SnackPosition.BOTTOM);

    // Upload images
    String? imageUrl1 = await _uploadToFirebase(image1.value!, "image1_${DateTime.now().millisecondsSinceEpoch}.jpg");
    String? imageUrl2 = await _uploadToFirebase(image2.value!, "image2_${DateTime.now().millisecondsSinceEpoch}.jpg");

    if (imageUrl1 != null && imageUrl2 != null) {
      Get.snackbar('Success', 'Images uploaded successfully!', snackPosition: SnackPosition.BOTTOM);
      print('Image 1 URL: $imageUrl1');
      print('Image 2 URL: $imageUrl2');
    }
  }
}
