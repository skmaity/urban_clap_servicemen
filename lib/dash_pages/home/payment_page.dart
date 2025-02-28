import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:urbanclap_servicemen/dash_board/dashboard_page.dart';
import 'package:urbanclap_servicemen/models/booking_model.dart';
import 'package:urbanclap_servicemen/services/booking_services.dart';
import 'package:urbanclap_servicemen/theme.dart';

class PaymentPage extends StatefulWidget {
  final BookingModel booking;
  const PaymentPage({super.key,required this.booking});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double serviceCharge = 100.0;
  double tax = 18.0;
  double platformFee = 10.0;


late BookingServices _bookingServices;
  @override
  void initState() {
    _bookingServices = BookingServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.booking.price + tax + platformFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Summary'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height-150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Charges Summary
                Text(
                  'Charges Summary',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Service Charge'),
                  trailing: Text('₹${widget.booking.price.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Text('Tax'),
                  trailing: Text('₹${tax.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Text('Platform Fee'),
                  trailing: Text('₹${platformFee.toStringAsFixed(2)}'),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Total Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
            
                // Section: Warnings
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  dashPattern: [8, 4],
                  color: Colors.red,
                  strokeWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Please note that cancellations are subject to our cancellation policy.',
                          style: TextStyle(color: Colors.red),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '• Once you proceed, you cannot change the service provider.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
            
                // Confirm Booking Button
                Center(
                  child: ElevatedButton(
                    onPressed: ()async {
            
            // Call this function when the booking is ready to be saved
            bool success = await _bookingServices.addNewBooking(widget.booking);
             
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Booking successfully added!")),
              );
              Get.offAll(()=> DashboardPage());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Failed to add booking. Please try again.")),
              );
            }
            
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyTheme.logoColorTheme,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Confirm Booking'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
