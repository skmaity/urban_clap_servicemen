import 'package:get/get.dart';

class Earning {
  final String date;
  final double amount;
  final String service;
  final String customerName;

  Earning({
    required this.date,
    required this.amount,
    required this.service,
    required this.customerName,
  });
}

class EarningController extends GetxController {
  var earnings = <Earning>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEarnings();
  }

  void loadEarnings() {
    earnings.value = [
      Earning(date: "2025-02-01", amount: 50.0, service: "Plumbing", customerName: "John Doe"),
      Earning(date: "2025-02-02", amount: 75.0, service: "AC Repair", customerName: "Jane Smith"),
      Earning(date: "2025-02-03", amount: 60.0, service: "Cleaning", customerName: "Mark Wilson"),
      Earning(date: "2025-02-04", amount: 90.0, service: "Electrician", customerName: "Sophia Brown"),
      Earning(date: "2025-02-05", amount: 120.0, service: "Carpentry", customerName: "Michael Johnson"),
      Earning(date: "2025-02-06", amount: 45.0, service: "Painting", customerName: "Emma Davis"),
      Earning(date: "2025-02-07", amount: 80.0, service: "AC Repair", customerName: "Liam Anderson"),
      Earning(date: "2025-02-08", amount: 100.0, service: "Plumbing", customerName: "Olivia Martinez"),
      Earning(date: "2025-02-09", amount: 110.0, service: "Cleaning", customerName: "Noah Thompson"),
      Earning(date: "2025-02-10", amount: 95.0, service: "Electrician", customerName: "Ava Wilson"),
      Earning(date: "2025-02-11", amount: 130.0, service: "Carpentry", customerName: "William Moore"),
      Earning(date: "2025-02-12", amount: 55.0, service: "Painting", customerName: "Charlotte White"),
    ];
  }
}
