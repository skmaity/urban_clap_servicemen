import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:urbanclap_servicemen/dash_pages/profile/about_us.dart';
import 'package:urbanclap_servicemen/dash_pages/profile/manage_locations/manage_location_page.dart';
import 'package:urbanclap_servicemen/dash_pages/profile/privacy_policy_screen.dart';
import 'package:urbanclap_servicemen/global_functions/user_data_controller.dart';
import 'package:urbanclap_servicemen/services/auth_service.dart';
import 'package:urbanclap_servicemen/theme.dart';

class ProfilePageDash extends StatefulWidget {
  const ProfilePageDash({super.key});

  @override
  State<ProfilePageDash> createState() => _ProfilePageDashState();
}

class _ProfilePageDashState extends State<ProfilePageDash> {

  UserDataController controller = Get.put(UserDataController());
  File? _imageFile;
  RxString name = ''.obs;
  RxString phone = ''.obs;
  RxString email = ''.obs;

    Future<void> loadUserDataFromSPF() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    name.value = prefs.getString('name') ?? '';
    phone.value = prefs.getString('phone') ?? '';
    email.value = prefs.getString('email') ?? '';
  }

  Widget buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        shape: ContinuousRectangleBorder(borderRadius:BorderRadius.circular(10)),
        leading: Icon(icon, color: Colors.grey),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  
late AuthService _authService;
  @override
  void initState() {
loadUserDataFromSPF();
    _authService = AuthService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  var user =  FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyTheme.logoColorTheme,
        title: Text('Profile & Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Picture Section
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Column(
                  children: [
                     Stack(
                        children: [
                          
                             CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (user?.photoURL?.isNotEmpty ?? false) 
                                  ? NetworkImage(user!.photoURL!)
                                  :  controller.userPhotoUrl.isNotEmpty ? NetworkImage(controller.userPhotoUrl.value) : const AssetImage('assets/default_profile.png') as ImageProvider,
                                                  ),
                        
                      
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: controller.changeProfilePictureTo,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    
                    SizedBox(height: 10),
                    Obx(()=> Text(name.value,style: TextStyle(fontSize: 14, color: Colors.grey))),
                    Obx(()=> Text( (
                      // user!.email ??
                       email.value).toString(), style: TextStyle(fontSize: 14, color: Colors.grey))),
                  ],
                ),
              ),
          
              // Container(
              //   // margin: EdgeInsets.symmetric(horizontal: 10),
              //   decoration: BoxDecoration(color: MyTheme.logoColorTheme,
              //   borderRadius: BorderRadius.circular(20)
              //   ),
              //   height: 80,
              //   width: double.infinity,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [Text('Total available balance: ',style: TextStyle(color: Colors.white),),
              //     Text('2000 ',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)
              //     ],),),
          
              // Divider(thickness: 1, color: Colors.grey[300]),
          
             // General Section
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 12.0), // More gap above and below section title
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text('General', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              //   ),
              // ),
              // buildProfileOption(Icons.settings_outlined, 'Profile Settings', () {}),
              // buildProfileOption(Icons.favorite_border, 'Favorite List', () {}), 
              // buildProfileOption(Icons.rate_review_outlined, 'My Reviews', () {}),
              // buildProfileOption(Icons.location_on_outlined, 'Manage Locations', () {Get.to(()=>ManageLocations());
              
              // }),
          
              Divider(thickness: 1, color: Colors.grey[300]),
              buildProfileOption(Icons.location_on_outlined, 'Manage Locations', ()=>Get.to(ManageLocationsPage())),  // Outline icon
              buildProfileOption(Icons.info_outline, 'About Us', () {
                Get.to(()=> AboutUsPage());
              }),  // Outline icon
              buildProfileOption(Icons.policy_outlined, 'Privacy Policy', ()=>Get.to(()=> WebViewScreen(title: 'Privacy Policy',url: 'https://doc-hosting.flycricket.io/urbanclap-privacy-policy/12999594-7850-46f3-b1da-dc11aab34744/privacy',))),
              buildProfileOption(Icons.verified_user_outlined, 'Term Of Use', ()=>Get.to(()=> WebViewScreen(title: 'Term of use',url: 'https://doc-hosting.flycricket.io/urbanclap-terms-of-use/e386ea84-8af3-4d19-a855-22c4f2e18fc6/terms',))), // Outline icon
             buildProfileOption(Icons.logout_outlined, 'Logout', () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text('Logout'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _authService.signOut(); // Perform logout
            },
          ),
        ],
      );
    },
  );
}),

            ],
          ),
        ),
      ),
    );
  }
}
