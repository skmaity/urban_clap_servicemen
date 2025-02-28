import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:urbanclap_servicemen/global_functions/user_data_controller.dart';
import 'package:urbanclap_servicemen/models/booking_model.dart';
import 'package:urbanclap_servicemen/models/serviceman_model.dart';

class BookingServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 User? user = FirebaseAuth.instance.currentUser;


  // Fetch Servicemen List
  Future<List<ServiceMan>> getServicemenList() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('serviceman').get();

      List<ServiceMan> servicemenList = snapshot.docs.map((doc) {
        return ServiceMan(
          imageUrl: doc['imageUrl'],
          name: doc['name'],
          rating: doc['rating'],
          specialty: doc['specialty'],
          id: doc['id'],
        );
      }).toList();

      return servicemenList;
    } catch (e) { 
      print("Error fetching servicemen: $e");
      return [];
    }
  }

  // Add New Booking to Firestore
  Future<bool> addNewBooking(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').doc(booking.bookingId).set({
        'service': booking.service,
        'bookingId': booking.bookingId,
        'date': booking.date.toIso8601String(),
        'time': booking.time,
        'address': booking.address,
        'serviceman': booking.serviceman,
        'serviceManId': booking.serviceManId,
        'customMsg': booking.customMsg,
        'status': booking.status,
        'price': booking.price,
        'userId': booking.userId,
      });
      print("Booking added successfully!");
      return true;
    } catch (e) {
      print("Error adding booking: $e");
      return false;
    }
  }

Future<List<BookingModel>> getAllBookings() async {
  try {
    QuerySnapshot snapshot = await _firestore
        .collection('bookings')
        .where('serviceManId', isEqualTo: user!.uid) // Filter by serviceManId
        .get();

    List<BookingModel> bookingsList = snapshot.docs.map((doc) {
      return BookingModel(
        service: doc['service'],
        bookingId: doc['bookingId'],
        date: DateTime.parse(doc['date']),
        time: doc['time'],
        address: doc['address'],
        serviceman: doc['serviceman'],
        customMsg: doc['customMsg'],
        status: BookingStatus.values.firstWhere(
          (e) => e.toString().split('.').last == doc['status'],
          orElse: () => BookingStatus.pending, // Default value if not found
        ),
        price: double.parse(doc['price'].toString()),
        userId: doc['userId'],
        serviceManId: doc['serviceManId'],
        latitude: doc['latitude'],
        longitude: doc['longitude'],
      );
    }).toList();

    return bookingsList;
  } catch (e) {
    print("Error fetching bookings: $e");
    return [];
  }
}



  Future<void> updateBooking(String bookingId, BookingModel updatedData) async {
    try {
      // Reference to the document with the specified bookingId
      QuerySnapshot snapshot = await _firestore
          .collection('bookings')
          .where('bookingId', isEqualTo: bookingId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Get the document ID of the matched booking
        String docId = snapshot.docs.first.id;

        // Convert BookingModel to a Map
        Map<String, dynamic> updatedDataMap = {
          'service': updatedData.service,
          'bookingId': updatedData.bookingId,
          'date': updatedData.date.toIso8601String(),
          'time': updatedData.time,
          'address': updatedData.address,
          'serviceman': updatedData.serviceman,
          'customMsg': updatedData.customMsg,
          'status': updatedData.status.toString().split('.').last, // Convert enum to String
          'price': updatedData.price,
          'userId': updatedData.userId,
          'serviceManId': updatedData.serviceManId,
          'latitude': updatedData.latitude,
          'longitude': updatedData.longitude,
        };

        // Update the document with new data
        await _firestore.collection('bookings').doc(docId).update(updatedDataMap);
        print("Booking updated successfully");
      } else {
        print("No booking found with the given bookingId");
      }
    } catch (e) {
      print("Error updating booking: $e");
    }
  }


}
