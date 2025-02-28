import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urbanclap_servicemen/dash_board/dashboard_page.dart';
import 'package:urbanclap_servicemen/firebase_options.dart';
import 'package:urbanclap_servicemen/global_functions/user_data_controller.dart';
import 'package:urbanclap_servicemen/login_signup/login_page.dart';
import 'package:urbanclap_servicemen/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp( MyApp());
} 

class MyApp extends StatelessWidget {
   MyApp({super.key});
   UserDataController controller = Get.put( UserDataController());
  @override 
  Widget build(BuildContext context) {
    return GetMaterialApp( 
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.josefinSansTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: MyTheme.logoColorTheme),
        useMaterial3: true,
      ), 
      home: FirebaseAuth.instance.currentUser == null ? const LoginPage() : const DashboardPage(),
    );
  }

  
}