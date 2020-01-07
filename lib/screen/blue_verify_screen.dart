import 'package:flutter/material.dart';
import './blue_screen.dart';
import './tabs_main_screen.dart';

class BlueVerifyScreen extends StatelessWidget {
  static const routeName = '/blue-verify';
  void toMainPage(BuildContext context) {
    Navigator.of(context).pushNamed(
      TabsMainScreen.routeName,
    );
  }

  void _cancel(BuildContext context) {
    // Navigator.of(context).pushNamed(
    //   FindDevicesScreen.routeName,
    // );
    Navigator.pop(context);
  }

  void _verify(BuildContext context) {
    // null interface for creating finger print
  }
  void _login(BuildContext context) {
    // null interface for creating finger print
  }

  void createFingerPrint() {
    // null interface for creating finger print
  }

  void resetFingerPrint() {
    // null interface for reset finger print
  }

  void verifyFingerPring() {
    // null interface for verify finger print
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          RaisedButton(
            child: Text('Cancel'),
            onPressed: () => _cancel(context),
          ),
          RaisedButton(
              child: Text('Verify'), onPressed: () => _verify(context)),
          RaisedButton(child: Text('Verify'), onPressed: () => _login(context)),
          RaisedButton(
            color: Colors.grey,
            child: Text(
              'APP(test)',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => toMainPage(context),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Verify', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Center(
          child: Text(
        'Process',
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
