import 'package:flutter/material.dart';
import 'package:urbanclap_servicemen/models/serviceman_model.dart';
import 'package:urbanclap_servicemen/services/booking_services.dart';

class SelectServiceManPage extends StatefulWidget {
  const SelectServiceManPage({super.key});

  @override
  State<SelectServiceManPage> createState() => _SelectServiceManPageState();
}

class _SelectServiceManPageState extends State<SelectServiceManPage> {
  final BookingServices _bookingServices = BookingServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Service Man'),
      ),
      body: FutureBuilder<List<ServiceMan>>(
        future: _bookingServices.getServicemenList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle empty data
            return const Center(child: Text('No servicemen found.'));
          } else {
            // Data is available
            final serviceMen = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: serviceMen.length,
                itemBuilder: (context, index) {
                  final serviceMan = serviceMen[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, serviceMan);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              serviceMan.imageUrl ?? 'https://picsum.photos/200',
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  serviceMan.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  serviceMan.specialty,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      serviceMan.rating.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
