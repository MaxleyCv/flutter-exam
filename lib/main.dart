import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Exam',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Flutter Exam'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Widget TextBox(Color color, String text) {
  return Container(
    width: 100,
    height: 40,
    child: Text(
      text,
      style: TextStyle(color: color),
    ),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _firstColumn = [
    "Left 1",
    "Left 2",
    "Left 3",
    "Left 4",
    "Left 5"
  ];
  final List<String> _secondColumn = [
    "Right 1",
    "Right 2",
    "Right 3",
    "Right 4",
    "Right 5"
  ];

  void _shuffleBlocks() {
    setState(() {
      Random rand = new Random();

      int c1Length = _firstColumn.length;
      int c2Length = _secondColumn.length;

      int columnToChoose = rand.nextInt(2);
      if (c2Length == 0 || (columnToChoose == 0 && c1Length != 0)) {
        String elementToChange = _firstColumn[rand.nextInt(c1Length)];
        _firstColumn.remove(elementToChange);
        _secondColumn.add(elementToChange);
      } else {
        String elementToChange = _secondColumn[rand.nextInt(c2Length)];
        _secondColumn.remove(elementToChange);
        _firstColumn.add(elementToChange);
      }
    });
  }

  void _takeBlockHome() {
    setState(() {
      List<String> redsInLeft = [];
      List<String> redsInRight = [];
      int counter = 0;
      for (String text in _firstColumn) {
        if (text.contains("Right")) {
          redsInLeft.add(text);
          counter += 1;
        }
      }

      for (String text in _secondColumn) {
        if (text.contains("Left")) {
          redsInRight.add(text);
          counter += 1;
        }
      }

      int leftLength = redsInLeft.length;
      Random rand = new Random();

      int el = rand.nextInt(counter);

      if (el < leftLength){
        _firstColumn.remove(redsInLeft[el]);
        _secondColumn.add(redsInLeft[el]);
      }
      else {
        el -= leftLength;
        _secondColumn.remove(redsInRight[el]);
        _firstColumn.add(redsInRight[el]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool discrepancyFound = false;

    List<Widget> leftColumn = [];
    for (String text in _firstColumn) {
      leftColumn
          .add(TextBox(text.contains("Left") ? Colors.grey : Colors.red, text));
      if (text.contains("Right")) {
        discrepancyFound = true;
      }
    }

    List<Widget> rightColumn = [];
    for (String text in _secondColumn) {
      rightColumn.add(
          TextBox(text.contains("Right") ? Colors.grey : Colors.red, text));
      if (text.contains("Left")) {
        discrepancyFound = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: leftColumn,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: rightColumn,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          discrepancyFound
              ? Positioned(
                  left: 30,
                  bottom: 20,
                  child: FloatingActionButton(
                    heroTag: 'back',
                    onPressed: _takeBlockHome,
                    child: const Icon(
                      Icons.home,
                      size: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              : Container(),
          Positioned(
            bottom: 20,
            right: 30,
            child: FloatingActionButton(
              heroTag: 'next',
              onPressed: _shuffleBlocks,
              child: const Icon(
                Icons.ramen_dining,
                size: 40,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
