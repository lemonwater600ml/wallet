import 'package:flutter/material.dart';
import './tabs_main_screen.dart';

class BluetoothScreen extends StatefulWidget {
  static const routeName = '/bluetooth-screen';
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  void toMainPage(BuildContext context) {
    Navigator.of(context).pushNamed(
      TabsMainScreen.routeName,
    );
  }

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Bluetooth discovery"),
        ),
        body: Container(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: Future.delayed(Duration(seconds: 3), ()=>{
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('Next Page(for test only)'),
                    onPressed: () => toMainPage(context),
                  ),
                }),
                builder: (c, s) => Center(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text('Next Page'),
                    onPressed: () => toMainPage(context),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
