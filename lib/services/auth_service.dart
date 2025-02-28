import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbanclap_servicemen/login_signup/login_page.dart';
import 'package:urbanclap_servicemen/widgets/myloader.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Google Sign-In 
  Future<UserCredential> signInWithGoogle() async {
    Myloader().showLoaderDialog(Get.context!);
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    UserCredential userCredential = await _auth.signInWithCredential(credential);

    // Save user data 
    await saveUserData(userCredential.user!);
    Get.back();
    return userCredential; 
  }

  // Email and Password Sign-Up
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user data
    await saveUserData(userCredential.user!);

    return userCredential;
  }

  // Email and Password Sign-In
  Future<UserCredential> signInWithEmail(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user data (Optional if you want to update info on login)
    await saveUserData(userCredential.user!);

    return userCredential;
  }

  // Phone Number Verification
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(String) codeSentCallback,
    Function(String) verificationFailedCallback,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        await saveUserData(userCredential.user!);
      },
      verificationFailed: (FirebaseAuthException e) {
        verificationFailedCallback(e.message ?? "Verification failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSentCallback(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // OTP Verification
  Future<UserCredential> verifyOTP(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    
    return userCredential;
  }

  // Save User Data to Firestore
  Future<void> saveUserData(User user, {String? name, String? profilePhotoUrl}) async {
    final userDoc = _firestore.collection('servicemens').doc(user.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // User doesn't exist, create new
      await userDoc.set({
        'uid': user.uid,
        'name': name ?? user.displayName ?? '',
        'email': user.email ?? '',
        'phone': user.phoneNumber ?? '',
        'profilePhotoUrl': profilePhotoUrl ?? user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      // Update existing data
      await userDoc.update({
        'name': name ?? user.displayName ?? '',
        'profilePhotoUrl': profilePhotoUrl ?? user.photoURL ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Logout Function
  Future<void> signOut() async {
    await _auth.signOut().whenComplete((){
    Get.offAll(()=> LoginPage());

    });
  }
}
 