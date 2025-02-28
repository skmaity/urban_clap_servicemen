import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urbanclap_servicemen/models/offers_model.dart';

class OfferServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all offers from Firestore
  Future<List<OffersModel>> getAllOffers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('offers').get();

      // Map Firestore documents to OffersModel objects
      List<OffersModel> offersList = snapshot.docs.map((doc) {
        return OffersModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return offersList;
    } catch (e) {
      print("Error fetching offers: $e");
      return [];
    }
  }
}
