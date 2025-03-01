import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/dash_pages/earnings/conreollers/earning_controller.dart';
import 'package:urbanclap_servicemen/theme.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  final EarningController _earningController = Get.put(EarningController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Earnings"),
        backgroundColor: MyTheme.logoColorTheme ,
      ),
      body: Column(
        children: [
          // Total Earnings Card
          Obx(() {
            double totalEarnings = _earningController.earnings.fold(
              0.0,
              (sum, earning) => sum + 170
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Total Earnings",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "₹ ${totalEarnings.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Earnings List
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _earningController.earnings.length,
                itemBuilder: (context, index) {
                  var earning = _earningController.earnings[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   backgroundColor: Colors.blueAccent,
                      //   child: Text(
                      //     earning.service[0], // First letter of service type
                      //     style: const TextStyle(color: Colors.white),
                      //   ),
                      // ),
                      // title: Text(
                      //   earning.,
                      //   style: const TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      subtitle: Text("${earning.userId} • ${earning.timestamp}"),
                      // trailing: Text(
                      //   "₹ ${earning.amount.toStringAsFixed(2)}",
                      //   style: const TextStyle(
                      //     color: Colors.green,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
