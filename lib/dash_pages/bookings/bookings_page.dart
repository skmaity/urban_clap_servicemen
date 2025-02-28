import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/dash_pages/bookings/booking_details_page.dart';
import 'package:urbanclap_servicemen/dash_pages/bookings/controllers/booking_page_controller.dart';
import 'package:urbanclap_servicemen/models/booking_model.dart';
import 'package:urbanclap_servicemen/theme.dart';

class BookingsPage extends StatefulWidget { 

  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final BookingPageController controller = Get.put(BookingPageController()); 

  @override
  void initState() {
    controller.loadBookings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Search Bar 
          TextField(
  controller: controller.searchBookingsController.value,
  decoration: InputDecoration(
    hintText: 'Search bookings...',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(12.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.logoColorTheme),
      borderRadius: BorderRadius.circular(12.0),
    ),
    prefixIcon: const Icon(Icons.search),
    suffixIcon: controller.searchBookingsController.value.text.isNotEmpty
        ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.searchBookingsController.value.clear();
              controller.loadBookings();
            },
          )
        : null,
  ),
  onChanged: (query) {
    controller.searchQuery.value = query;
  controller.searchBookings();

  }
),

            const SizedBox(height: 15),
            
            // Bookings List 
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.filteredBookings.isEmpty) {
                  return const Center(child: Text('No bookings found.'));
                }

                return ListView.builder(
                  itemCount: controller.filteredBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.filteredBookings[index];
                    final isEven = index % 2 == 0;
                    return InkWell(
                     onTap: () async { 
  final result = await Get.to(() => BookingDetailsPage(booking: booking));

  if (result == true) { 
    controller.loadBookings();
  }
},
                      child: Card( 
                        color: isEven ? Colors.blue.shade50 : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.build, color: Colors.white),
                          ),
                          title: Text(booking.service, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("Serviceman: ${booking.serviceman}", style: TextStyle(color: Colors.grey.shade600)),
                              Text("Address: ${booking.address}", style: TextStyle(color: Colors.grey.shade600)),
                              Text("Status: ${booking.status.toString().split('.').last}", style: TextStyle(fontWeight: FontWeight.bold, color: _getStatusColor(booking.status))),
                              Row(
                                children: [
                                  Icon(Icons.currency_rupee_outlined),
                                  SizedBox(width: 5,),
                                  Text("Price: ${booking.price} ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                                ],
                              ),
                      
                            ],
                          ),
                          trailing: _buildActionButtons(booking),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(booking) { 
    if (booking.status == "Pending") {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () => controller.acceptBooking(booking.bookingId),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: () => controller.cancelBooking(booking.bookingId),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
