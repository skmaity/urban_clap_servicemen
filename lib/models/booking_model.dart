

import 'package:intl/intl.dart';

enum BookingStatus { pending, confirmed,cancelled ,completed}
class BookingModel {
  final String service;
  final String bookingId;
  final DateTime date;
  final String time;
  final String address;
  final String serviceman;
  final String customMsg;
  final BookingStatus status;
  final double price;
  final String userId;
  final String serviceManId;
  final String latitude;
  final String longitude;




  BookingModel({
    required this.service,
    required this.bookingId,
    required this.date,
    required this.time,
    required this.address,
    required this.serviceman,
    required this.customMsg,
    required this.status,
    required this.price,
    required this.userId,
    required this.serviceManId,
    required this.latitude,
    required this.longitude
  });

  // ✅ Add copyWith method
  BookingModel copyWith({
    String? service,
    String? bookingId,
    DateTime? date,
    String? time,
    String? address,
    String? serviceman,
    String? customMsg,
    BookingStatus? status,
    double? price,
    String? userId,
    String? serviceManId,
    String? longitude,
    String? latitude,


  }) {
    return BookingModel(
      service: service ?? this.service,
      bookingId: bookingId ?? this.bookingId,
      date: date ?? this.date,
      time: time ?? this.time,
      address: address ?? this.address,
      serviceman: serviceman ?? this.serviceman,
      customMsg: customMsg ?? this.customMsg,
      status: status ?? this.status,
      price: price ?? this.price,
      userId: userId ?? this.userId,
      serviceManId: serviceManId ?? this.serviceManId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude
    );
  }
   String getFormattedDate({String format = "dd/MM/yyyy"}) {
    return DateFormat(format).format(date);
  }
}
