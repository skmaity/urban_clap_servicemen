import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/models/notification_model.dart';

class NotificationsController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  // Fetch notifications for the current user
  void fetchNotifications() {
    String userId = _auth.currentUser?.uid ?? '';
    // String userId = '1';


    if (userId.isEmpty) return;

    _firestore
        .collection('notification')
        .where('userId', isEqualTo: userId) // Filter notifications for the logged-in user
        .snapshots()
        .listen((snapshot) {
      var fetchedNotifications = snapshot.docs.map((doc) {
        return NotificationModel.fromJson(doc.data(), doc.id);
      }).toList();
      notifications.assignAll(fetchedNotifications);
    });
  }

  // Add a new notification (for testing)
  Future<void> addNotification(String title, String message) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    await _firestore.collection('notification').add({
      'title': title,
      'message': message,
      'date': DateTime.now().toString(),
      'userId': userId, // Store notification for a specific user
      'isRead': false,
    });
  }

  // Mark a notification as read
  void markAsRead(String id) async {
    await _firestore.collection('notification').doc(id).update({'isRead': true});
  }

  // Delete a notification
  void deleteNotification(String id) async {
    await _firestore.collection('notification').doc(id).delete();
  }

  // Mark all notifications as read
  void markAllAsRead() async {
    for (var notif in notifications) {
      await _firestore.collection('notification').doc(notif.id).update({'isRead': true});
    }
  }

  // Clear all notifications
  void clearNotifications() async {
    var batch = _firestore.batch();
    for (var notif in notifications) {
      batch.delete(_firestore.collection('notification').doc(notif.id));
    }
    await batch.commit();
  }
}
