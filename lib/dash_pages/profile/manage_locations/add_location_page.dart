import 'package:flutter/material.dart';

class AddLocationPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  AddLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Location Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add the new location to the list
                String newLocation = _controller.text;
                if (newLocation.isNotEmpty) {
                  // Pass the new location back to the previous screen
                  Navigator.pop(context, newLocation);
                }
              },
              child: Text('Add Location'),
            ),
          ],
        ),
      ),
    );
  }
}
