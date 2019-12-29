import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'package:flutter/services.dart';

import './tabs_main_screen.dart';
import './wallet_screen.dart';

class BluetoothScreen extends StatefulWidget {
  static const routeName = '/bluetooth-screen';
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the bluetooth
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;
  bool _connected = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    bluetoothConnectionState();
  }

  // We are using async callback for using await
  Future<void> bluetoothConnectionState() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // For knowing when bluetooth is connected and when disconnected
    bluetooth.onStateChanged().listen((state) {
      switch (state.toString()) {
        case 'FlutterBluetoothSerial.CONNECTED':
          setState(() {
            _connected = true;
            _pressed = false;
          });

          break;

        case 'FlutterBluetoothSerial.DISCONNECTED':
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;

        default:
          print(state);
          break;
      }
    });

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

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
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Bluetooth Connection"),
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "PAIRED DEVICES",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton(
                      items: _getDeviceItems(),
                      onChanged: (value) => setState(() => _device = value),
                      value: _device,
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed:
                          _pressed ? null : _connected ? _disconnect : _connect,
                      child: Text(_connected ? 'Disconnect' : 'Connect'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "DEVICE 1",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed:
                              _connected ? _sendOnMessageToBluetooth : null,
                          child: Text("ON"),
                        ),
                        FlatButton(
                          onPressed:
                              _connected ? _sendOffMessageToBluetooth : null,
                          child: Text("OFF"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      "NOTE: If you cannot find the device in the list, please turn on bluetooth and pair the device by going to the bluetooth settings",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                child: Text('Next Page(for test only)'),
                onPressed: () => toMainPage(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() {
    if (_device == null) {
      show('No device selected');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth
              .connect(_device)
              .timeout(Duration(seconds: 10))
              .catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
        }
      });
    }
  }

  // Method to disconnect bluetooth
  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
  }

  // Method to send message,
  // for turning the bletooth device on
  void _sendOnMessageToBluetooth() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.write("1");
        show('Device Turned On');
      }
    });
  }

  // Method to send message,
  // for turning the bletooth device off
  void _sendOffMessageToBluetooth() {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.write("0");
        show('Device Turned Off');
      }
    });
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}


//   void toMainPage(BuildContext context) {
//     Navigator.of(context).pushNamed(
//       TabsMainScreen.routeName,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Text('Waiting for connection.'),
//           RaisedButton(
//             child: Text('Next Page(for test only)'),
//             onPressed: () => toMainPage(context),
//           )
//         ],
//       ),
//     );
//   }
// }
