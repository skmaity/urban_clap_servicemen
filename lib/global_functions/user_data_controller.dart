import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:urbanclap_servicemen/models/serviceman_model.dart';

class UserDataController extends GetxController {
  RxString userPhotoUrl = "".obs;
  RxList<ServiceMan> allServicemenList = <ServiceMan>[].obs;
  Rxn<ServiceMan> currentUser = Rxn<ServiceMan>();
  RxBool isProfilePictureUploading = false.obs;
 late User? user;

  @override
  void onInit() {
  user = FirebaseAuth.instance.currentUser;
    setProfileFromUser();
    fetchCurrentServicemanData();
    super.onInit();
  }

  /// Fetch all servicemen from Firestore
 Future<void> fetchCurrentServicemanData() async {
  try {
    currentUser.close();
    // Fetch the specific document of the current user
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('servicemens')
        .doc(user!.uid)
        .get();

    if (documentSnapshot.exists) { 
      // Convert Firestore document to ServiceMan model 
      currentUser.value = ServiceMan.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } else {
      print("No data found for the current user.");
    }
  } catch (e) {
    print("Error fetching current serviceman data: $e");
  }
}


  /// Set the profile photo from Firebase user or Firestore data
  void setProfileFromUser() {
    if (user != null) {
      if (user!.photoURL != null && user!.photoURL!.isNotEmpty) {
        userPhotoUrl.value = user!.photoURL!;
      } else {
        if (currentUser.value != null){
          
          if(currentUser.value!.imageUrl.isNotEmpty) {
          userPhotoUrl.value = currentUser.value!.imageUrl;
        }
        }
      }
    }
  }


   Future<void> changeProfilePictureTo() async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return; // If no image is selected, return

      File imageFile = File(pickedFile.path);
      isProfilePictureUploading.value = true; // Show loading state

      // Upload image to Firebase Storage
      String fileName = basename(imageFile.path);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user!.uid}/$fileName');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update user profile in Firebase Auth
      await user!.updatePhotoURL(downloadUrl);
      await FirebaseAuth.instance.currentUser!.reload(); // Refresh user data

      // Update profile picture in Firestore
      await FirebaseFirestore.instance
          .collection('servicemens')
          .doc(user!.uid)
          .update({'profilePhotoUrl': downloadUrl});

      // Update local state
      userPhotoUrl.value = downloadUrl;

      Get.snackbar("Success", "Profile picture updated successfully!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("Error changing profile picture: $e");
      Get.snackbar("Error", "Failed to update profile picture",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isProfilePictureUploading.value = false; // Hide loading state
    }
  }
}
