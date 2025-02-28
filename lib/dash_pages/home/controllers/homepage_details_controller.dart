import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:urbanclap_servicemen/models/services_model.dart';

class HomepageDetailsController extends GetxController {
  // List of earnings (20 data points)
  final RxList<double> totalEarnings = <double>[].obs;

  // List of services (30 data points)
  RxList<ServiceModel> totalServices = <ServiceModel>[].obs;

  // List of bookings (example with 10 data points)
  final RxList<Map<String, dynamic>> totalBooking = <Map<String, dynamic>>[].obs;

  // List of categories (example with 5 data points)
  final RxList<Map<String, dynamic>> totalCategory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadEarnings();
    getAllServices();
    _loadBooking();
    _loadCategories();
  }

  void _loadEarnings() {
    // Generating 20 earnings values.
    // For example, increasing earnings by 100.0 for each entry.
    for (int i = 1; i <= 20; i++) {
      totalEarnings.add(100.0 * i);
    }
  }

Future<List<ServiceModel>> getAllServices() async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('services')
        .get();

    List<ServiceModel> services = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      
      // If Firestore doesn't store an 'id' field, use document ID
      return ServiceModel.fromJson({...data, 'id': doc.id});
    }).toList();

    print('Loaded ${services.length} services.');
    totalServices.assignAll(services);
    return services;
  } catch (error) {
    print("Error loading services: $error");
    return [];
  }
}

  void _loadBooking() {
    // Generating 10 booking entries.
    for (int i = 1; i <= 10; i++) {
      totalBooking.add({
        'bookingId': i,
        'customerName': 'Customer $i',
        'date': DateTime.now().subtract(Duration(days: i)).toString(),
      });
    }
  }

  void _loadCategories() {
    // Defining 5 sample categories.
    List<String> categories = ['AC Repair', 'Cleaning', 'Beauty', 'Plumbing', 'Cooking'];
    for (int i = 0; i < categories.length; i++) {
      totalCategory.add({
        'categoryId': i + 1,
        'categoryName': categories[i],
      });
    }
  }
}
