import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/login_signup/resetpassword_page.dart';
import 'package:urbanclap_servicemen/login_signup/signup_page.dart';
import 'package:urbanclap_servicemen/login_signup/signupwith_phone_page.dart';
import 'package:urbanclap_servicemen/profile/profile_page.dart';
import 'package:urbanclap_servicemen/services/auth_service.dart';
import 'package:urbanclap_servicemen/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String googleLogoPath = 'assets/login_signup_icons/google.png';
  String phoneLogoPath = 'assets/login_signup_icons/iphone.png';
  String guestLogoPath = 'assets/login_signup_icons/account.png';

  late AuthService _authService;
  @override
  void initState() {
    _authService = AuthService();
    super.initState();
  }

  @override
  void dispose() {
    _email.clear();
    _password.clear();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                // Logo or App Name
                Row(
                  children: [
                    // SizedBox(width: 20,),
                    FlutterLogo(
                      textColor: Colors.amber,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'My app',
                    )
                  ],
                ),
                SizedBox(height: 30),
                // Sign Up Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Sign In as a Provider',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                // Email Field
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade800),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Password Field
                TextFormField(
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade800),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => ResetpasswordPage());
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: MyTheme.logoColorTheme,
                      ),
                    ),
                  ),
                ), 
                SizedBox(height: 20),
                // Login Button
              SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: _isLoading
        ? null // Disable button when loading
        : () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                _isLoading = true;
              });
              _authService  
                  .signInWithEmail(_email.text, _password.text)
                  .then((v) {
                Get.snackbar(
                  'Login Successful',
                  'Logged in successfully with ${_email.text}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                Get.offAll(() => ProfilePage(email: _email.text.isNotEmpty ? _email.text.trim() : ""  , phone: '', user: v,));
              }).catchError((e) {
                Get.snackbar(
                  'Login Failed',
                  e.message,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }).whenComplete(() {
                setState(() {
                  _isLoading = false; // Stop loading after process completes
                });
              });
            }
          },
    style: ElevatedButton.styleFrom(
      // backgroundColor: MyTheme.logoColorTheme,
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: MyTheme.logoColorTheme),
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    child: _isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          )
        : Text(
            'Login as a Servicemen',
            style: TextStyle(
              fontSize: 18,
              color: MyTheme.logoColorTheme,
            ),
          ),
  ),
),
                SizedBox(height: 15),
                // Sign Up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () { 
                        Get.to(()=>SignupPage());
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: MyTheme.logoColorTheme,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () { 
                        _authService.signInWithGoogle().then((user) {
                          Get.snackbar(
                            'Login Successful',
                            'Logged in successfully with ${_email.text}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          Get.offAll(() => ProfilePage(email: _email.text,phone: '',user: user,));
                        }).catchError((error) {
                          Get.snackbar(
                            'Login Failed',
                            error.message ?? 'An error occurred during login.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        });
                      },
                      child: Card(
                        elevation: 13,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset(googleLogoPath),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Get.to(SignupwithPhonePage());
                      },
                      child: Card(
                        elevation: 13,
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Image(image: AssetImage(phoneLogoPath))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
