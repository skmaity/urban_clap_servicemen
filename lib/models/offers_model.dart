class OffersModel {
  final String offerId;          // Unique ID for each offer
  final String title;            // Title of the offer (e.g., "20% off on AC Services")
  final String description;      // Detailed description of the offer
  final double discountPercentage; // Discount percentage (e.g., 20.0 for 20%)
  final DateTime startDate;      // When the offer starts
  final DateTime endDate;        // When the offer ends
  final bool isActive;           // Whether the offer is currently active
  final String serviceId;        // ID of the service this offer applies to
  final String termsAndConditions; // Terms and conditions for the offer

  OffersModel({
    required this.offerId,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.serviceId,
    required this.termsAndConditions,
  });

  // Factory method to create OffersModel from Firestore document
  factory OffersModel.fromMap(Map<String, dynamic> data, String documentId) {
    return OffersModel(
      offerId: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      discountPercentage: data['discountPercentage']?.toDouble() ?? 0.0,
      startDate: DateTime.parse(data['startDate']),
      endDate: DateTime.parse(data['endDate']),
      isActive: data['isActive'] ?? false,
      serviceId: data['serviceId'] ?? '',
      termsAndConditions: data['termsAndConditions'] ?? '',
    );
  }

  // Convert OffersModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'offerId': offerId,
      'title': title,
      'description': description,
      'discountPercentage': discountPercentage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'serviceId': serviceId,
      'termsAndConditions': termsAndConditions,
    };
  }
}
