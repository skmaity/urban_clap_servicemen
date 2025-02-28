import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/dash_pages/home/controllers/homepage_details_controller.dart';
import 'package:urbanclap_servicemen/theme.dart';

class HomeWidgetsDetails extends StatefulWidget {
  final String icon;
  final String title;
  final String type;

  const HomeWidgetsDetails({
    super.key,
    required this.icon,
    required this.title,
    required this.type,
  });

  @override
  State<HomeWidgetsDetails> createState() => _HomeWidgetsDetailsState();
} 

class _HomeWidgetsDetailsState extends State<HomeWidgetsDetails> {
  final HomepageDetailsController controller = Get.put(HomepageDetailsController());
  
  @override
  void initState() {
    super.initState();
    controller.onInit();
  }

  Widget _buildBody() {
    switch (widget.type) {
      case 'Total earning':
        return Obx(
          () => ListView.builder(
            itemCount: controller.totalEarnings.length,
            itemBuilder: (context, index) {
              return Container(
                color: index % 2 == 0 ? Colors.brown.shade50 : Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text(
                    "Earning: \$${controller.totalEarnings[index].toStringAsFixed(2)}",
                  ),
                ),
              );
            },
          ),
        );
      case 'Total service':
        return Obx(
          () => ListView.builder(
            itemCount: controller.totalServices.length,
            itemBuilder: (context, index) {
              final service = controller.totalServices[index];
              return Container(
                color: index % 2 == 0 ? Colors.brown.shade50 : Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.miscellaneous_services),
                  title: Text(service.category),
                  subtitle: Text("Price: ${service.price}"),
                ),
              );
            },
          ),
        );
      case 'Total Booking':
        return Obx(
          () => ListView.builder(
            itemCount: controller.totalBooking.length,
            itemBuilder: (context, index) {
              final booking = controller.totalBooking[index];
              return Container(
                color: index % 2 == 0 ? Colors.brown.shade50 : Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.book_online),
                  title: Text(booking['customerName'] ?? ''),
                  subtitle: Text("Date: ${booking['date']}"),
                ),
              );
            },
          ),
        );
      case 'Total category':
        return Obx(
          () => ListView.builder(
            itemCount: controller.totalCategory.length,
            itemBuilder: (context, index) {
              final category = controller.totalCategory[index];
              return Container(
                color: index % 2 == 0 ? Colors.brown.shade50 : Colors.transparent,
                child: ListTile(
                  leading: const Icon(Icons.category),
                  title: Text(category['categoryName'] ?? ''),
                ),
              );
            },
          ),
        );
      default:
        return const Center(child: Text("No data found"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type, style: TextStyle(color: MyTheme.logoColorTheme)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(widget.icon),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}