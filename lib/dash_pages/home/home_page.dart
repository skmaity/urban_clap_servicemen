import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:urbanclap_servicemen/dash_pages/home/controllers/graph_controller.dart';
import 'package:urbanclap_servicemen/dash_pages/home/home_widgets_details.dart';
import 'package:urbanclap_servicemen/dash_pages/home/notifications/notifications_page.dart';
import 'package:urbanclap_servicemen/dash_pages/home/sales_graph/sales_graph.dart';
import 'package:urbanclap_servicemen/global_functions/global_functions.dart';
import 'package:urbanclap_servicemen/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Map<String, String>> services = [
    {
      'icon': 'assets/service_icons/customer-review.png',
      'name': 'Total service',
      'value': '257'
    },
    // {
    //   'icon': 'assets/service_icons/application.png',
    //   'name':'Total category',
    //   'value': '43'
    // },
  ];

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];
  late final GlobalFunctions _globalFunctions = Get.put(GlobalFunctions());
  GraphController controller = Get.put(GraphController());

  late User? user;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    _globalFunctions.requestLocation(context);
    super.initState();
  }

  

  // int _currentIndex = 0;
  //  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
  onTap: () async {
    if(_globalFunctions.address.value == ''){
 _globalFunctions.showWorkingOnIt();
await Future.delayed(Duration(seconds: 1));
    }
   
   // Check the current location permission status
    PermissionStatus status = await Permission.location.status;

    // If permission is not granted, request it 
    if (!status.isGranted) {
      status = await Permission.location.request();

      // If still not granted, show a dialog to the user
      if (!status.isGranted) {
        showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
              'Location permission is required to use this feature. Please allow location access in your device settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
    Get.back();

        return;
      }
    } 

    // At this point, location permission is granted.
    // Place your action here that requires location access.
    // For example, navigate to a location-based page or update the UI.

    debugPrint('Location permission granted. Proceeding...');
    Get.back();
  },
  borderRadius: BorderRadius.circular(20),
  child: CircleAvatar(
    backgroundColor: MyTheme.logoColorTheme.withAlpha(40),
    child: Icon(
      Icons.location_on,
      color: MyTheme.logoColorTheme,
    ),
  ),
),
                        SizedBox(
                          width: 10,
                        ),
                        Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Home'),
                              SizedBox(
                                  width: 150,
                                  child: Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    _globalFunctions.address.value,
                                    style: TextStyle(color: Colors.grey),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(()=>NotificationsPage());
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: CircleAvatar(
                        backgroundColor: MyTheme.logoColorTheme.withAlpha(40),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Divider(),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Total Sales',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 25,color: Colors.grey),),
                    SizedBox(width: 20,),
                     Obx(
                       ()=> SizedBox(
                                 width: 60,
                                 height: 34,
                                 child: TextButton(
                                   style: ButtonStyle().copyWith(backgroundColor: WidgetStatePropertyAll(MyTheme.logoColorTheme.withAlpha(100))),
                                   onPressed: () {
                                     setState(() {
                                       controller.isAvg.value = !controller.isAvg.value;
                                     });
                                   },
                                   child: Text(
                                     'avg',
                                     style: TextStyle(
                                       fontSize: 12,
                                       color:  controller.isAvg.value
                                           ?Colors.blueGrey
                                           : Colors.blueGrey.withAlpha(100)
                                     ),
                                   ),
                                 ),
                               ),
                     ),
                  ],
                ),
                SalesGraph(),
                SizedBox(height: 10,),

                Divider(),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Get.to(() => HomeWidgetsDetails(
                             icon: services[index]['icon']!,
                             title: services[index]['value']!,
                             type: services[index]['name']!
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(13),
                                      child: Image.asset(
                                        services[index]['icon']!,
                                        width: 40, // Adjust size as needed
                                        height: 40,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      services[index]['name']!,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    // Text(
                                    //   services[index]['value']!,
                                    //   style: const TextStyle(fontSize: 14),
                                    // ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.grey,
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
