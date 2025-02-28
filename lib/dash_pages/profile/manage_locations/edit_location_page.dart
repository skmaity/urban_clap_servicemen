import 'package:flutter/material.dart';

class EditLocationPage extends StatelessWidget {
  final String currentName;
  final ValueChanged<String> onSave;
  final TextEditingController _controller;

  EditLocationPage({super.key, required this.currentName, required this.onSave})
      : _controller = TextEditingController(text: currentName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Location'),
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
                String updatedName = _controller.text;
                if (updatedName.isNotEmpty) {
                  onSave(updatedName);
                  Navigator.pop(context);
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
