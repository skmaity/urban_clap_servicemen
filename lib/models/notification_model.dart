import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String date;
  final String userId; // User-specific notifications
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.userId,
    this.isRead = false,
  });

  // Convert Firestore JSON to Model
  factory NotificationModel.fromJson(Map<String, dynamic> json, String id) {
    return NotificationModel(
      id: id,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      date: json['date'] ?? '',
      userId: json['userId'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }

  // Convert Model to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'date': date,
      'userId': userId,
      'isRead': isRead,
    };
  }
   String get formattedDate {
    try {
      DateTime parsedDate = DateTime.parse(date); // Parse from ISO format
      return DateFormat("dd MMM yy").format(parsedDate); // Format date
    } catch (e) {
      return date; // Return original if parsing fails
    }
  }
}
