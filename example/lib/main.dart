import 'package:flutter/material.dart';
import 'package:jiggle/jiggle.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final JiggleController controller = JiggleController();

  void _jiggleStuff() {
    controller.toggle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jiggle Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Jiggle(
              jiggleController: controller,
              // extent: 9,
              child: Text(
                'You have pushed the button this many times:',
              ),
            ),
            Jiggle(
              jiggleController: controller,
              extent: 8,
              duration: Duration(milliseconds: 500),
              child: Text(
                '😂',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Jiggle(
              jiggleController: controller,
              useGestures: true,
              extent: 3,
              child: Container(
                height: 200,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20)),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _jiggleStuff,
        icon: Icon(Icons.vibration),
        label: Text("Jiggle"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
