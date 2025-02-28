import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/dash_pages/home/controllers/notifications_controller.dart';
import 'package:urbanclap_servicemen/models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationsController controller = Get.put(NotificationsController());
  void showConfirmationDialog(BuildContext context, {required String title, required String message, required VoidCallback onConfirm}) {
  Get.defaultDialog(
    title: title,
    middleText: message,
    textConfirm: "Yes",
    textCancel: "No",
    confirmTextColor: Colors.white,
    onConfirm: () {
      onConfirm();
      Get.back(); // Close dialog after confirmation
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text("Notifications"),
  actions: [
    TextButton(
      onPressed: () => showConfirmationDialog(
        context,
        title: "Mark All as Read",
        message: "Are you sure you want to mark all notifications as read?",
        onConfirm: controller.markAllAsRead,
      ),
      child: Image.asset('assets/double-tick.png', height: 28),
    ),
    IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () => showConfirmationDialog(
        context,
        title: "Clear Notifications",
        message: "Are you sure you want to delete all notifications?",
        onConfirm: controller.clearNotifications,
      ),
    ),
  ],
),

      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(child: Text("No notifications available"));
        }
        return ListView.separated(
          itemCount: controller.notifications.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final NotificationModel notification = controller.notifications[index];
            return Card(
              elevation: 1,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: notification.isRead ? Colors.white : Colors.blue.shade50,
              child: ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: notification.isRead ? Colors.grey : Colors.blue,
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.message),
                    const SizedBox(height: 5),
                    Text(
                      notification.formattedDate,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!notification.isRead)
                      IconButton(
                        icon: const Icon(Icons.mark_email_read, color: Colors.blue),
                        onPressed: () => controller.markAsRead(notification.id),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteNotification(notification.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
