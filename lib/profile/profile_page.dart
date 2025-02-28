import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanclap_servicemen/dash_board/dashboard_page.dart';
import 'package:urbanclap_servicemen/global_functions/user_data_controller.dart';
import 'package:urbanclap_servicemen/theme.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  final String phone;
  final UserCredential user;

  const ProfilePage({super.key,required this.email,required this.phone,required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  UserDataController controller = UserDataController();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  String defaultProfile = 'assets/default_profile.png';
  File? _profileImageFile;
  bool _isLoading = false;
    String? _imageUrl;


  Future<void> pickAndUploadImage(String uid) async {
    final picker = ImagePicker();

    // Show dialog to choose image source
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (source == null) return; // User canceled selection

    // Pick image
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return; // User didn't pick an image

    setState(() {
      _profileImageFile = File(pickedFile.path); // Update UI with selected image
    });

    try {
      // Upload to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures').child('$uid.jpg');

      await storageRef.putFile(_profileImageFile!);

      // Get download URL
      String imageUrl = await storageRef.getDownloadURL();

      setState(() {
        _imageUrl = imageUrl; // Update UI with uploaded image URL
      });

      print("Image uploaded successfully: $imageUrl");
    } catch (e) {
      print('Image upload error: $e');
    }
  }
  Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.snackbar('Cleared', 'User data removed!',
        snackPosition: SnackPosition.BOTTOM);
  }
 Future<void> saveUserDataToSPF() async {
  clearUserData();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', nameController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('email', emailController.text);

    Get.snackbar('Success', 'User data saved successfully!',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> _saveUserProfile(String name,String phone,String email,String photo) async {
    User? user = FirebaseAuth.instance.currentUser;
 setState(() {
      _isLoading = true;
    });

    final userDoc = _firestore.collection('servicemens').doc(user!.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // User doesn't exist, create new
      await userDoc.set({
        'uid': user.uid,
        'name': name ?? user.displayName,
        'email': user.email ?? email,
        'phone': user.phoneNumber ?? phone,
        'profilePhotoUrl': photo ?? user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Update existing data 
      await userDoc.update({
        'name': name ?? user.displayName ?? '',
        'phone': user.phoneNumber ?? phone,
        'profilePhotoUrl': photo ?? user.photoURL ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
   

    final uid = widget.user.user!.uid;

    try {
      await FirebaseFirestore.instance.collection('servicemens').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'profilePhotoUrl': photo ?? '', 
        'updatedAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {

    } finally {
      setState(() {
        _isLoading = false;
      });
    }

  }

  setValuesIfAny() {
    if (widget.email != '') {
      emailController.text = widget.email;
      setState(() {});
    }
    if (widget.phone != '') {
      phoneController.text = widget.phone;
      setState(() {});
    }
  }


  @override
  void initState() {
    setValuesIfAny();
    super.initState();
  }

  @override
  void dispose() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();

    super.dispose();
  }

  GlobalKey<FormState> _key = GlobalKey();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Edit Profile'), SizedBox()],
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                ()=> Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImageFile != null
                          ? FileImage(_profileImageFile!)
                          :controller.userPhotoUrl.isNotEmpty ? NetworkImage(controller.userPhotoUrl.value) : AssetImage(defaultProfile) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.blue,
                          size: 30,
                        ),
                        onPressed: controller.changeProfilePictureTo,
                      ), 
                    ),
                    controller.isProfilePictureUploading.value? Positioned(
                      bottom: 0,
                      top: 0,
                      right: 0,
                      left: 0,
                      child: CircularProgressIndicator()) : SizedBox(),

                  ],
                ),
              ),
              SizedBox( 
                height: 40,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Form(
  key: _key,
  child: Column(
    children: [
      TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Full Name',
          border: UnderlineInputBorder(),
          prefixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your name';
          } else if (value.trim().length < 2) {
            return 'Please enter a valid name';
          }
          return null; // Proper validation return
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        
      ),
      const SizedBox(height: 20),
      TextFormField(
        readOnly: widget.email.isNotEmpty,
        controller: emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: UnderlineInputBorder(),
          prefixIcon: Icon(Icons.email),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your email';
          } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
              .hasMatch(value.trim())) {
            return 'Please enter a valid email address';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
      const SizedBox(height: 20),
      TextFormField(
        readOnly: widget.phone.isNotEmpty,
        controller: phoneController,
        decoration: const InputDecoration(
          labelText: 'Mobile Number',
          border: UnderlineInputBorder(),
          prefixIcon: Icon(Icons.phone),
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your mobile number';
          } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
            return 'Please enter a valid 10-digit mobile number';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,

      ),
    ],
  ),
),
              SizedBox(
                height: 150,
              ),
            SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () async {

      if(_key.currentState!.validate()){
 setState(() {
        _isLoading = true; // Show loading spinner
      });

      try {  

        await _saveUserProfile(nameController.text,phoneController.text,emailController.text,_imageUrl ?? "").then((v){
          saveUserDataToSPF();
        });
        
        // Show success snackbar
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        );

        // Navigate to DashboardPage
        Get.to(() => DashboardPage());
      } catch (e) {
        // Show error snackbar
        Get.snackbar( 
          'Error',
          'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        );
      } finally {
        setState(() {
          _isLoading = false; // Hide loading spinner
        });
      }
      }
     
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: MyTheme.logoColorTheme,
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    child: _isLoading
        ? CircularProgressIndicator(color: Colors.white)
        : Text(
            'Save Changes',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
