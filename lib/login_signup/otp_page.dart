import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pinput/pinput.dart';
import 'package:urbanclap_servicemen/profile/profile_page.dart';
import 'package:urbanclap_servicemen/services/auth_service.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final String phone;

  const OtpPage({super.key, required this.verificationId,required this.phone});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AuthService _authService;
  @override
  void initState() {
    _authService = AuthService();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

 verifyOTP() async {
  setState(() {
    _isLoading = true; // Show loader
  });

  try {
    // Attempt to verify the OTP
    UserCredential userCredential = await _authService.verifyOTP(
      widget.verificationId,
      _otpController.text,
    );

    if (userCredential.user != null) {
      // If the user is authenticated, navigate to the dashboard
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Verification Successful',
          message: 'Your account has been verified.',
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );
      Get.offAll(() => ProfilePage(phone: widget.phone, email: '', user: userCredential));
    } else {
      // If verification fails, show a snackbar using GetX
      Get.showSnackbar(
        const GetSnackBar(
          title: 'Verification Failed',
          message: 'Please try again.',
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Handle errors during OTP verification
    Get.showSnackbar(
      GetSnackBar(
        title: 'Error',
        message: e.toString(),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() {
      _isLoading = false; // Hide loader after operation
    });
  }
}

      bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter OTP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'We have sent an OTP to your phone number',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Pinput(
                length: 6,
                controller: _otpController,
                focusNode: _focusNode,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                submittedPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onCompleted: (pin) {
                  verifyOTP();
                }),
            const SizedBox(height: 20),
           ElevatedButton(
  onPressed: _isLoading
      ? null  // Disable button while loading
      : () async {
          if (_otpController.text.isNotEmpty && _otpController.text.length > 5) {
            setState(() {
              _isLoading = true;  // Start loading
            });
            await verifyOTP();  // Call the OTP verification function
            setState(() {
              _isLoading = false;  // Stop loading after verification
            });
          } else {
            Get.showSnackbar(
              GetSnackBar(
                title: 'Error',
                message: 'Please enter a valid OTP',
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
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
      : const Text(
          'Verify OTP',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Add resend OTP logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OTP Resent Successfully!')),
                );
              },
              child: const Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
