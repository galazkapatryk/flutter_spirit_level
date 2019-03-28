import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int x = 0;
  int y = 0;
  double xDotPosition = 0;
  double yDotPosition = 0;
  bool isCorrectLevel = false;
  var badColors = [
    Colors.red,
    Colors.redAccent,
  ]
  var correctColors = [
    Colors.green,
    Colors.greenAccent,
  ];

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = calculateXValue(event);
        y = calculateYValue(event);
        isCorrectLevel = (x == 0 && x == y);
        xDotPosition = getXDotPosition(event.x);
        yDotPosition = getYDotPosition(event.y);
        print(((event.y * 10).round()));
      });
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  double getXDotPosition(double xValue) {
    if (isCorrectLevel)
      return 0;
    else
      return xValue;
  }
  double getYDotPosition(double yValue) {
    if (isCorrectLevel)
      return 0;
    else
      return yValue;
  }

  int calculateYValue(AccelerometerEvent event) {
    return (event.y * 10).round();
  }

  int calculateXValue(AccelerometerEvent event) {
    return (event.x * 10 - 2).round();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
              gradient: new RadialGradient(
                radius: 1,
                colors: getBackgroundColor(),
                              )
          )),
      Center(
        child:AnimatedContainer(
          duration: Duration(milliseconds: 50),
          child: Transform.translate(
        offset: Offset(10 * xDotPosition, 20 * yDotPosition),
        child: ClipOval(
            child: Container(
          width: 100,
          height: 100,
          color: Colors.white,
        )),
      ))),
      Center(
          child:AnimatedContainer(
              duration: Duration(milliseconds: 50),
              child: Transform.translate(
                offset: Offset(-10 * xDotPosition, -10 * yDotPosition),
                child: ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.white,
                    )),
              ))),
    ]);
  }

  getBackgroundColor() {
    if (isCorrectLevel)
      return correctColors;
    else
      return badColors;
  }
}
