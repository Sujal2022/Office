/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinning_wheel_game/Pages/wheel_options.dart';

class CustomDrawer extends StatefulWidget {
  final Function(String) onWheelSelected;

  const CustomDrawer({super.key, required this.onWheelSelected, required String selectedWheel});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String selectedWheel = "Yes/No"; // Default wheel

  @override
  void initState() {
    super.initState();
    _loadSelectedWheel();
  }

  Future<void> _loadSelectedWheel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedWheel = prefs.getString("selected_wheel") ?? "Yes/No"; // Load saved wheel or default
    });
  }

  Future<void> _saveSelectedWheel(String wheelName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected_wheel", wheelName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              child: Text(
                'Select a Wheel',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(color: Colors.lightBlueAccent.shade100),
            ),
          ),
          Expanded(
            child: ListView(
              children: wheelOptions.keys.map((wheelName) {
                return ListTile(
                  leading: _buildWheelPreview(wheelOptions[wheelName]!),
                  title: Text(
                    wheelName,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: selectedWheel == wheelName ? FontWeight.bold : FontWeight.normal,
                      color: selectedWheel == wheelName ? Colors.blue : Colors.black,
                    ),
                  ),
                  tileColor: selectedWheel == wheelName ? Colors.blue.shade100 : null,
                  onTap: () async {
                    await _saveSelectedWheel(wheelName);
                    setState(() {
                      selectedWheel = wheelName;
                    });

                    widget.onWheelSelected(wheelName);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheelPreview(List<Map<String, dynamic>> options) {
    return CircleAvatar(
      radius: 25,
      child: Stack(
        children: options.asMap().entries.map((entry) {
          double startAngle = (entry.key / options.length) * 360;
          return Positioned.fill(
            child: CustomPaint(
              painter: _WheelSlicePainter(entry.value['color'], startAngle, 360 / options.length),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _WheelSlicePainter extends CustomPainter {
  final Color color;
  final double startAngle;
  final double sweepAngle;

  _WheelSlicePainter(this.color, this.startAngle, this.sweepAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2);
    canvas.drawArc(rect, startAngle * 3.1416 / 180, sweepAngle * 3.1416 / 180, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}*/

/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spinning_wheel_game/Pages/wheel_options.dart';

class CustomDrawer extends StatelessWidget {
  final Function(String) onWheelSelected;
  final String selectedWheel;

  const CustomDrawer({super.key, required this.onWheelSelected, required this.selectedWheel});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 100,
           child:  DrawerHeader(
              child: Text(
                'Select a Wheel',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(color: Colors.lightBlueAccent.shade100),
            ),
          ),

          Expanded(
            child: ListView(
              children: wheelOptions.keys.map((wheelName) {
                return ListTile(
                  leading: _buildWheelPreview(wheelOptions[wheelName]!),
                  title: Text(
                    wheelName,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: selectedWheel == wheelName ? FontWeight.bold : FontWeight.normal,
                      color: selectedWheel == wheelName ? Colors.blue : Colors.black,
                    ),
                  ),
                  tileColor: selectedWheel == wheelName ? Colors.blue.shade100 : null,
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setString("selected_wheel", wheelName);

                    onWheelSelected(wheelName);
                    Navigator.pop(context);
                  },

                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Generates a small preview of the wheel using colors
  Widget _buildWheelPreview(List<Map<String, dynamic>> options) {
    return CircleAvatar(
      radius: 25,
      child: Stack(
        children: options.asMap().entries.map((entry) {
          double startAngle = (entry.key / options.length) * 360;
          return Positioned.fill(
            child: CustomPaint(
              painter: _WheelSlicePainter(entry.value['color'], startAngle, 360 / options.length),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Custom Painter to create a small wheel preview
class _WheelSlicePainter extends CustomPainter {
  final Color color;
  final double startAngle;
  final double sweepAngle;

  _WheelSlicePainter(this.color, this.startAngle, this.sweepAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2);
    canvas.drawArc(rect, startAngle * 3.1416 / 180, sweepAngle * 3.1416 / 180, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}*/

/*
import 'package:flutter/material.dart';
import 'package:spinning_wheel_game/Pages/wheel_options.dart';
class CustomDrawer extends StatelessWidget {
  final Function(String) onWheelSelected;
  final String selectedWheel; // Track the selected wheel
  const CustomDrawer({super.key, required this.onWheelSelected, required this.selectedWheel});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              'Select a Wheel',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            decoration: BoxDecoration(color: Colors.lightBlueAccent.shade100),
          ),
          ...wheelOptions.keys.map((wheelName) {
            return ListTile(
              title: Text(
                wheelName,
                style: TextStyle(
                  fontWeight: selectedWheel == wheelName ? FontWeight.bold : FontWeight.normal,
                  color: selectedWheel == wheelName ? Colors.blue : Colors.black,
                ),
              ),
              tileColor: selectedWheel == wheelName ? Colors.blue.shade100 : null,
              onTap: () {
                onWheelSelected(wheelName);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
*/
