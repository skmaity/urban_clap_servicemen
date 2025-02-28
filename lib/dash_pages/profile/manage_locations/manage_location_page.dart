import 'package:flutter/material.dart';
import 'package:urbanclap_servicemen/dash_pages/profile/manage_locations/add_location_page.dart';
import 'package:urbanclap_servicemen/dash_pages/profile/manage_locations/edit_location_page.dart';

class ManageLocationsPage extends StatefulWidget {
  const ManageLocationsPage({super.key});

  @override
  _ManageLocationsPageState createState() => _ManageLocationsPageState();
}

class _ManageLocationsPageState extends State<ManageLocationsPage> {
  List<String> locations = ['Home', 'Work']; // Example list of locations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Locations'),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(locations[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => EditLocationPage(
      currentName: locations[index],
      onSave: (newName) {
        setState(() {
          locations[index] = newName;
        });
      },
    ),
  ),
);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      locations.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
  final newLocation = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddLocationPage()),
  );
  if (newLocation != null) {
    setState(() {
      locations.add(newLocation);
    });
  }
},
        child: Icon(Icons.add),
      ),
    );
  }
}
