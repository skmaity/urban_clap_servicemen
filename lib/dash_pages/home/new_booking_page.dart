import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/dash_pages/home/payment_page.dart';
import 'package:urbanclap_servicemen/dash_pages/home/select_serviceman_page.dart';
import 'package:urbanclap_servicemen/global_functions/global_functions.dart';
import 'package:urbanclap_servicemen/models/booking_model.dart';
import 'package:urbanclap_servicemen/models/serviceman_model.dart';
import 'package:urbanclap_servicemen/theme.dart';
import 'package:uuid/uuid.dart';


class NewBookingPage extends StatefulWidget {
  final String bookingName;
  final String userId;
  const NewBookingPage({super.key, required this.bookingName,required this.userId});

  @override
  State<NewBookingPage> createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String address = '';
  String selectedServiceManName = '';
  String selectedServiceManId = '';

  TextEditingController customMessageController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _navigateToSelectServiceMan() async {
    final ServiceMan result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectServiceManPage()),
    );
    if (result != null) {
      setState(() {
        selectedServiceManName = result.name;
        selectedServiceManId = result.id;

      });
    }
  }

late final GlobalFunctions _globalFunctions = Get.put(GlobalFunctions());
@override
  void initState() {
   _globalFunctions.requestLocation(context);
    super.initState();
  }
  TextEditingController addressController = TextEditingController();
  void _showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Booking: ${widget.bookingName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Date and Time
              Text('Select Date & Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(selectedDate == null ? 'Select Date' : '${selectedDate!.toLocal()}'.split(' ')[0]),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text(selectedTime == null ? 'Select Time' : selectedTime!.format(context)),
                  ),
                ],
              ),
              Divider(height: 40),

              // Section 2: Address
              Text('Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Obx(
                (){
                 addressController.text =  _globalFunctions.address.value;
return TextField(
  controller:addressController , 
                  onChanged: (value) => setState(() => address = value),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your address',
                  ),
                );
                } 
              ),
              Divider(height: 40),

              // Section 3: Select Service Man
              Text('Select Service Man', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _navigateToSelectServiceMan,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  dashPattern: [8, 4],
                  color: Colors.blue,
                  strokeWidth: 2,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      selectedServiceManName.isEmpty ? 'Select Service Man' : selectedServiceManName,
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Divider(height: 40),

              // Section 4: Custom Message
              Text('Custom Message', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: customMessageController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter any special instructions or message',
                ),
              ),
              SizedBox(height: 20),
 // Submit Button
Center(
  child: TextButton.icon(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
      backgroundColor: WidgetStatePropertyAll(MyTheme.logoColorTheme),
    ),
    onPressed: () {
      // Validation logic
      if (selectedDate == null) {
        _showError('Please select a date.');
        return;
      }
      if (selectedTime == null) {
        _showError('Please select a time.');
        return;
      }
      if (addressController.text.isEmpty) {
        _showError('Please enter your address.');
        return;
      }
      if (selectedServiceManName.isEmpty) {
        _showError('Please select a serviceman.');
        return;
      }

      var uuid = Uuid();
      // Create BookingModel instance with all required data
      var bookingData = BookingModel(  
        service: widget.bookingName,
        bookingId: uuid.v4(),
        date: selectedDate!,
        time: selectedTime!.format(context),
        address: addressController.text,
        serviceman: selectedServiceManName,
        serviceManId: selectedServiceManId,
        customMsg: customMessageController.text,
        status: BookingStatus.pending,
        price: 150.0,
        userId: widget.userId,
        latitude: '',
        longitude: ''

      );

      // Navigate to PaymentPage
      Get.to(() => PaymentPage(booking: bookingData));
    },
    iconAlignment: IconAlignment.end,
    icon: Icon(Icons.arrow_forward_rounded),
    label: Text('Next'),
  ),
)


             
            ],
          ),
        ),
      ),
    );
  }
}