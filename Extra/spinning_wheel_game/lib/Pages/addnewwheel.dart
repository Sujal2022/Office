/*
import 'package:flutter/material.dart';
import '../Colour_Picker/ColorPickerDialog.dart';
import '../Database/db_helper.dart';

class AddWheelPage extends StatefulWidget {
  @override
  _AddWheelPageState createState() => _AddWheelPageState();
}

class _AddWheelPageState extends State<AddWheelPage> {
  final TextEditingController _wheelNameController = TextEditingController();
  final List<Map<String, dynamic>> _fields = [];  // Stores {name, color}
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _addField() {
    setState(() {
      _fields.add({"name": "", "color": Colors.blue}); // Default color
    });
  }

  void _saveWheel() async {
    String wheelName = _wheelNameController.text.trim();
    if (wheelName.isEmpty || _fields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter wheel name and add at least one field.")),
      );
      return;
    }

    // Save the wheel
    int wheelId = await _databaseHelper.insertCategory(wheelName);

    // Save the fields (items) under that wheel
    for (var field in _fields) {
      await _databaseHelper.insertWheelItem(wheelId, field['name'], field['color'].toString() as Color);
    }

    Navigator.pop(context); // Close the screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Wheel")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Wheel Name Input
            TextField(
              controller: _wheelNameController,
              decoration: InputDecoration(labelText: "Wheel Name"),
            ),
            SizedBox(height: 20),

            // Field List
            Expanded(
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: TextField(
                      onChanged: (value) => _fields[index]['name'] = value,
                      decoration: InputDecoration(labelText: "Field Name"),
                    ),
                    trailing: GestureDetector(
                      onTap: () async {
                        Color? newColor = await showDialog(
                          context: context,
                          builder: (context) => ColorPickerDialog(initialColor: Colors.blue,),
                        );
                        if (newColor != null) {
                          setState(() {
                            _fields[index]['color'] = newColor;
                          });
                        }
                      },
                      child: CircleAvatar(backgroundColor: _fields[index]['color']),
                    ),
                  );
                },
              ),
            ),

            // Add Field Button
            ElevatedButton(
              onPressed: _addField,
              child: Text("Add Field"),
            ),

            // Save Wheel Button
            ElevatedButton(
              onPressed: _saveWheel,
              child: Text("Save Wheel"),
            ),
          ],
        ),
      ),
    );
  }
}
*/
