/*
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'confetti_example.dart';
import 'create_wheel.dart';
import 'custom_wheel.dart';

void main() {
  runApp(MaterialApp(home: ConfettiExample()) );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Timer timer;
  late Random random;
  late String result;
  late double degree;
  late int time;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    random = Random();
    degree = 0;
    result = "";

  }

  */
/*void rotatewheel()
  {
    time = 3000;
    timer = Timer.periodic(Duration(milliseconds: 100), (timer){
      if(time>0)
        {
          setState(() {
            degree = random.nextInt(360).toDouble();
            result =calculatePointer(degree);
          });
        }
    });
    time = time-100;
  }*//*

  void rotatewheel() {
    time = 3000; // Total duration to spin
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (time > 0) {
        setState(() {
          degree = random.nextInt(360).toDouble();
          result = calculatePointer(degree);
        });
        time -= 100; // Decrement time inside the Timer block
      } else {
        timer.cancel(); // Stop the timer when time reaches zero
      }
    });
  }


  String calculatePointer(double degree)
  {
    String res="";
    int lowpoint = 0;
    int arc = 30;
    int sectors = 12;

    for(int i=sectors;i>0;i--)
      {
        if(degree>lowpoint && degree< lowpoint + arc){

          res = i.toString();
          break;
        }
        lowpoint = lowpoint + arc;

      }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 400,
              child: Stack(
                children: [
                  Positioned(child: Align(
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: 3.14/180*degree,
                      child: Image(
                        height: 350, width: 350,
                        image: AssetImage("assets/wheel1.png"),
                      ),
                    ),
                  )),
                  Positioned(child: Align(
                    alignment: Alignment.topCenter,
                    child: Image(
                      height: 50, width: 50,
                      image: AssetImage("assets/p1.png"),
                    ),

                  ))
                ],
              ),
            ),

            Container(
              child: Text(result, style:
              TextStyle(
                decoration: TextDecoration.none,
                fontSize: 50,
                color: Colors.blue
              ),),

            ),

            TextButton(onPressed: (){
              rotatewheel();
            }, child: Text("Press Me"))
          ],
        ),
      ),
    );
  }
}

*/
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RouletteScreen(),
    );
  }
}

class RouletteScreen extends StatelessWidget {
  final List<Map<String, dynamic>> roulettes = [
    {'title': 'Yes/No', 'colors': [Colors.green, Colors.red]},
    {'title': 'Food', 'colors': [Colors.orange, Colors.pink, Colors.brown, Colors.green, Colors.purple]},
    {'title': 'Date ideas', 'colors': [Colors.brown, Colors.blue, Colors.orange, Colors.yellow]},
    {'title': 'Love or no love?', 'colors': [Colors.pink, Colors.red, Colors.blue]},
    {'title': 'Movie night', 'colors': [Colors.black, Colors.yellow, Colors.blue, Colors.white]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: Text('Roulettes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: roulettes.length,
                itemBuilder: (context, index) {
                  return RouletteCard(roulettes[index]);
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
              ),
              child: Text('Add', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class RouletteCard extends StatelessWidget {
  final Map<String, dynamic> roulette;

  RouletteCard(this.roulette);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: _buildWheelIcon(roulette['colors']),
        ),
        title: Text(roulette['title'], style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }

  Widget _buildWheelIcon(List<Color> colors) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: colors,
          stops: List.generate(colors.length, (index) => index / colors.length.toDouble()),
        ),
      ),
    );
  }
}
