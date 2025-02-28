import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/dash_pages/bookings/controllers/destination_controller.dart';
import 'package:urbanclap_servicemen/theme.dart';

class DestinationConfirmation extends StatefulWidget {
  const DestinationConfirmation({super.key});

  @override
  State<DestinationConfirmation> createState() =>
      _DestinationConfirmationState();
}

class _DestinationConfirmationState extends State<DestinationConfirmation> {

DestinationController controller = Get.put(DestinationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reached the Destination')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => controller.pickImage(1),
                      child:  DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [6, 3],
                borderType: BorderType.RRect,
                radius: Radius.circular(10),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Obx(
                            ()=> controller.image1.value == null
                                ?  Center(child: Text('Tap to upload Image 1'))
                                : Image.file(controller.image1.value!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => controller..pickImage(2),
                      child:  DottedBorder(
                color: Colors.grey,
                strokeWidth: 1,
                dashPattern: [6, 3],
                borderType: BorderType.RRect,
                radius: Radius.circular(10),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Obx(
                            ()=> controller.image2.value == null
                                ?  Center(child: Text('Tap to upload Image 2'))
                                : Image.file(controller.image2.value!, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50,),
                Column(
                  children: [
                    Text(
                      
                        "When the servicemen reach the customer's location, they need to upload two images of the site before starting the work.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey,fontSize: 18),
                        ),
                  ],
                ),
                SizedBox(height: 50,),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: ButtonStyle().copyWith(
                                backgroundColor:
                                    WidgetStatePropertyAll(MyTheme.logoColorTheme)),
                            onPressed: controller.submit,
                            child: const Text('Submit'),
                          ),
                        ),
                      ),
                    ],
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
