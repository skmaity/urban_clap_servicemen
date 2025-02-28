import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class GraphController extends GetxController {
  RxBool isAvg = false.obs;
  RxList<FlSpot> salesData = <FlSpot>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSalesData();
  }

  Future<void> fetchSalesData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot snapshot = await firestore.collection('sales').get();

      List<FlSpot> tempData = [];

      for (var doc in snapshot.docs) {
        int month = int.parse(doc['month']) ; // Ensure month values are between 0-11
        double sales =double.parse(doc['sales']) ; // Sales value in thousands (or adjust as needed)
sales = sales /10000;
        tempData.add(FlSpot(month.toDouble(), sales));
      }

      // Sort data by month (optional, if needed)
      tempData.sort((a, b) => a.x.compareTo(b.x));

      salesData.assignAll(tempData);
    } catch (e) {
      print("Error fetching sales data: $e");
    }
  }
}
