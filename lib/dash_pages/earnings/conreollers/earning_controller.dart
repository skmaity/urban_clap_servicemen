import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Earning {
  final String bookingId;
  final String paymentId;
  final String serviceMenId;
  final String userId;
  final String status;
  final String timestamp;

  Earning({
    required this.bookingId,
    required this.paymentId,
    required this.serviceMenId,
    required this.userId,
    required this.status,
    required this.timestamp,
  });

  // Factory method to create an Earning object from a Firestore document
  factory Earning.fromFirestore(Map<String, dynamic> data) {
        Timestamp firestoreTimestamp = data['timestamp'] ?? Timestamp.now();
    String formattedDate = DateFormat('d MMM y').format(firestoreTimestamp.toDate());
    return Earning(
      bookingId: data['bookingId'] ?? '',
      paymentId: data['paymentId'] ?? '',
      serviceMenId: data['serviceMenId'] ?? '',
      userId: data['userId'] ?? '',
      status: data['status'] ?? '',
      timestamp: formattedDate,
    );
  }
}

class EarningController extends GetxController {
  var earnings = <Earning>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadEarnings();
  }

  void loadEarnings() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('payments')
          .where('serviceMenId', isEqualTo: userId)
          .get();

      earnings.value = snapshot.docs.map((doc) {
        return Earning.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error loading earnings: $e");
    }
  }
}
