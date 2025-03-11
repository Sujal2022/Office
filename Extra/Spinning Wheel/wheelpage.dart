import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'editpage.dart';


class Wheelpage extends StatefulWidget {
  const Wheelpage({super.key});

  @override
  State<Wheelpage> createState() => _WheelpageState();
}

class _WheelpageState extends State<Wheelpage>
{
  StreamController<int> controller = StreamController<int>.broadcast();
  late ConfettiController confettiController;

  List<FortuneItem> wheelitem = [
    FortuneItem(
      child: Text(
        'Yes',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Increased font size
      ),
      style: FortuneItemStyle(color: Colors.red.shade100),
    ),
    FortuneItem(
      child: Text(
        'No',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Increased font size
      ),
      style: FortuneItemStyle(color: Colors.green.shade100),
    )
  ];
  Map<String, List<FortuneItem>> wheelOptions = {
    'Movies': [
    FortuneItem(
      child: Text('Inception', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      style: FortuneItemStyle(color: Colors.blue.shade100),
    ),
    FortuneItem(
      child: Text('Avatar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      style: FortuneItemStyle(color: Colors.orange.shade100),
    ),
    FortuneItem(
      child: Text('Titanic', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      style: FortuneItemStyle(color: Colors.purple.shade100),
    ),
    ]
  };


  String selectedOption = "";
  Color? wheelBackgroundColor;
  bool showResult = false;
  bool isSpinning = false;
  TextEditingController optioncontroller = TextEditingController();
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    confettiController.dispose();
    controller.close();
    super.dispose();
  }

  /*void spinWheel() {
    int selectedIndex = Random().nextInt(wheelitem.length);
    controller.add(selectedIndex);

    setState(() {
      isSpinning = true;
      showResult = false;
      selectedOption = "";
      wheelBackgroundColor = null;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isSpinning = false;
        selectedOption = (wheelitem[selectedIndex].child as Text).data ?? "";
        wheelBackgroundColor = wheelitem[selectedIndex].style!.color;
        showResult = true;
      });

      confettiController.play();
      // Start confetti when the result appears
      *//*if(isSpinning)
      {
        confettiController.stop();
      }
      else{
        confettiController.play();
      }
      isSpinning = !isSpinning;*//*
      //confettiController.play();
    });
  }*/
  void spinWheel() {
    int selectedIndex = Random().nextInt(wheelitem.length);
    controller.add(selectedIndex);

    setState(() {
      isSpinning = true;
      showResult = false;
      selectedOption = "";
      wheelBackgroundColor = null;
    });

    // Wait for the wheel animation to complete before showing the result
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isSpinning = false;
      });

      // Slight additional delay to ensure smooth transition
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          selectedOption = (wheelitem[selectedIndex].child as Text).data ?? "";
          wheelBackgroundColor = wheelitem[selectedIndex].style!.color;
          showResult = true;
        });

        confettiController.play(); // Start confetti when the result appears
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(

          appBar: AppBar(
            title: const Text('Wheel Decide', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.lightBlueAccent.shade100,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: isSpinning
                  ? RadialGradient(
                colors: [Colors.white, Colors.black],
                stops: [0.0, 1.0],
                center: Alignment.center,
                radius: 1.0,
              )
                  : null,
              color: isSpinning ? null : wheelBackgroundColor,
              image: DecorationImage(
                image: AssetImage('assets/img.png'), // Add your pattern image here
                fit: BoxFit.cover,
                opacity: 0.1, // You can adjust the opacity for a more subtle effect
              ),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 15,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            height: 300,
                            width: 300,
                            child: FortuneWheel(
                              selected: controller.stream,
                              items: wheelitem,
                              physics: CircularPanPhysics(
                                duration: const Duration(seconds: 2),
                                curve: Curves.decelerate,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: spinWheel,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Icon(Icons.refresh, color: Colors.black, size: 30),
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 50),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: showResult ? 1.0 : 0.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        "Selected Option: $selectedOption",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          blastDirection: -pi/2,// Shoots confetti upwards
          emissionFrequency: 0.02,
          numberOfParticles: 80,
          gravity: 0.1,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 20), // Adjust padding as needed
            child: FloatingActionButton(
              onPressed: () async {
                List<FortuneItem>? updatedItems = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Editpage(wheelitem: wheelitem),
                  ),
                );

                if (updatedItems != null) {
                  setState(() {
                    wheelitem = updatedItems;
                  });
                }
              },
              child: Icon(Icons.edit, size: 30),
              backgroundColor: Colors.lightBlueAccent.shade100,
            ),
          ),
        ),

      ],
    );
  }
}
