import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/dash_pages/bookings/controllers/booking_page_controller.dart';
import 'package:urbanclap_servicemen/dash_pages/bookings/destination_confirmation.dart';
import 'package:urbanclap_servicemen/dash_pages/chat/chat_page.dart';
import 'package:urbanclap_servicemen/models/booking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbanclap_servicemen/theme.dart';

class BookingDetailsPage extends StatefulWidget {
  final BookingModel booking;
  const BookingDetailsPage({super.key, required this.booking});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  BookingPageController bookingPageController = Get.put(BookingPageController());
  late GoogleMapController mapController;
  double lat = 0.0;
  double long = 0.0;

  RxBool isPending = false.obs;
  
  late final LatLng _location ; 

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    isPending.value = widget.booking.status == BookingStatus.pending;
    lat =  double.parse(widget.booking.latitude);
    long = double.parse(widget.booking.longitude);
    _location = LatLng(lat, long);
    super.initState();
  } 

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context, true); // Pass true to indicate changes

        }, icon: Icon(Icons.arrow_back_rounded)),
        backgroundColor: Colors.blueAccent,
        title: const Text('Booking Details', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Service: ${widget.booking.service}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 10),
                    // Text('Customer: ${widget.booking.userId}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    // const SizedBox(height: 5),
                    // Text('Phone: ${widget.booking.bookingId}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    const SizedBox(height: 5),
                    Text('Address: ${widget.booking.address}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    const SizedBox(height: 5), 
                    Text('Date: ${widget.booking.getFormattedDate()}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    const SizedBox(height: 5),
                    Text('Time: ${widget.booking.time}', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                    const SizedBox(height: 5),
                    Text("Status: ${widget.booking.status.toString().split('.').last}", style: const TextStyle(fontSize: 16, color: Colors.blue)),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ButtonStyle().copyWith(
                        backgroundColor: WidgetStatePropertyAll(MyTheme.logoColorTheme),
                      ),
                      onPressed: (){
                        Get.to(()=> ChatPage(reciverUserId:widget.booking.userId,bookingId: widget.booking.bookingId,)); 
                      }, child: Text('Chat with user'))
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children :[
GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _location,
                      zoom: 14.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('userLocation'),
                        position: _location,
                      ),
                    },
                  ),

                  isPending.value != true ?Positioned(
                    bottom: 10,
                    left: 10,
                    child: ElevatedButton(
                        style: ButtonStyle().copyWith(
                          backgroundColor: WidgetStatePropertyAll(Colors.black.withAlpha(30)),
                        ),
                        onPressed: (){
                          Get.to(()=> DestinationConfirmation()); 
                        }, child: Text('reached the destination?',style: TextStyle(color: Colors.white),)),
                  ) : SizedBox()

                  ] 
                ),
              ),
            ),
           
             widget.booking.status == BookingStatus.pending && isPending.value == true ? 
              SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
              _showConfirmationDialog( 
                context,
                "Accept Booking",
                "Are you sure you want to accept this booking?", 
                () {
                  bookingPageController.acceptBooking(widget.booking.bookingId);
                },
              );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Accept', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
              _showConfirmationDialog(
                context,
                "Reject Booking",
                "Are you sure you want to reject this booking?",
                () {
                  bookingPageController.cancelBooking(widget.booking.bookingId);
                },
              );
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Reject', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ) :SizedBox()


 
          ],
        ),
      ),
    );
  }
  void _showConfirmationDialog(
  BuildContext context,
  String title,
  String message,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              isPending.value = false;
setState(() {
  
});
              Navigator.of(context).pop(); // Close the dialog
              onConfirm(); // Execute the confirmed action
            },
            child: const Text("Confirm", style: TextStyle(color: Colors.green)),
          ),
        ],
      );
    },
  );
}
}
