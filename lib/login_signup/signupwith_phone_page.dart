import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:urbanclap_servicemen/login_signup/otp_page.dart';
import 'package:urbanclap_servicemen/services/auth_service.dart';
import 'package:urbanclap_servicemen/theme.dart';

class SignupwithPhonePage extends StatefulWidget {
  const SignupwithPhonePage({super.key});

  @override
  State<SignupwithPhonePage> createState() => _SignupwithPhonePageState();
}

class _SignupwithPhonePageState extends State<SignupwithPhonePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phone = TextEditingController();
  String _completePhoneNumber='';


  late AuthService _authService;
  @override
  void initState() {
    _authService = AuthService();
    super.initState();
  }
    bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80),
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
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Sign up as a provider',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 120),
      IntlPhoneField(
        controller: _phone,
        decoration: InputDecoration(
          labelText: 'Phone Number',
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade800),
          ),
        ),
        initialCountryCode: 'IN',
       onChanged: (phone) {
          _completePhoneNumber = phone.completeNumber; // Store full phone number with country code
        },
      ),
                    ],
                  ),
                  // Logo or App Name

                  Text(
                    'Enter your phone number to receive an OTP for verification. Input the OTP correctly to complete the signup process.',
                    style: TextStyle(color: Colors.grey),
                  ),

                  // Login Button
               Padding(
  padding: const EdgeInsets.only(bottom: 100),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _isLoading
          ? null  // Disable button while loading
          : () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;  // Start loading
                });
                try {
                  await _authService.verifyPhoneNumber(
                    _completePhoneNumber,
                    (verificationId) {
                      setState(() {
                        _isLoading = false;  // Stop loading on success before navigating
                      });
                      Get.to(() => OtpPage( 
                            verificationId: verificationId,
                            phone: _phone.text,
                          ));
                    },
                    (errorMessage) {
                      setState(() {
                        _isLoading = false;  // Stop loading on error
                      });
                      Get.snackbar(
                        'Verification Failed',
                        errorMessage,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    },
                  );
                } catch (e) {
                  setState(() {
                    _isLoading = false;  // Stop loading on exception
                  });
                  Get.snackbar(
                    'Sign Up Failed',
                    e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
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
              'Next',
              style: TextStyle(
                fontSize: 18,
                color: MyTheme.logoColorTheme
              ),
            ),
    ),
  ),
)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
