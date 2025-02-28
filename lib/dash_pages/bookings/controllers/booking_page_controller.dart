import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/models/booking_model.dart';
import 'package:urbanclap_servicemen/services/booking_services.dart';

class BookingPageController extends GetxController {
  var bookings = <BookingModel>[].obs;
  var filteredBookings = <BookingModel>[].obs;
  var isLoading = false.obs;
  final searchQuery = ''.obs;

  Rx<TextEditingController> searchBookingsController = TextEditingController().obs;
  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => searchBookings(), time: const Duration(milliseconds: 500));
  }

  void loadBookings() async { 
    isLoading(true);
    try {
  
      var fetchedBookings = await BookingServices().getAllBookings();  
      bookings.assignAll(fetchedBookings);
      filteredBookings.assignAll(fetchedBookings);
    } finally {
      isLoading(false); 
    }
  }

  void searchBookings() { 
    if (searchQuery.value.isEmpty) {
      filteredBookings.assignAll(bookings);
    } else {
      filteredBookings.assignAll(bookings.where((booking) =>
          booking.serviceman.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          booking.address.toLowerCase().contains(searchQuery.value.toLowerCase()) || 
          booking.service.toLowerCase().contains(searchQuery.value.toLowerCase())
          
          ));
    }
  }

  void acceptBooking(String bookingId) async {
    int index = bookings.indexWhere((booking) => booking.bookingId == bookingId);
    if (index != -1) {
      bookings[index] = bookings[index].copyWith(status: BookingStatus.confirmed);
      await BookingServices().updateBooking(bookingId, bookings[index]);
      searchBookings(); // Refresh filtered list
    }
  }

  void cancelBooking(String bookingId) async {
    int index = bookings.indexWhere((booking) => booking.bookingId == bookingId);
    if (index != -1) {
      bookings[index] = bookings[index].copyWith(status: BookingStatus.cancelled);
      await BookingServices().updateBooking(bookingId, bookings[index]);
      searchBookings(); // Refresh filtered list
    }
  }
}
