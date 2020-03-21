import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import './blue_connected_screen.dart';
import './blue_verify_screen.dart';
// import '../widgets/blue_widgets.dart';

class BlueScreen extends StatelessWidget {
  static const routeName = '/blue-screen';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);
  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString()}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  static const routeName = '/find-devices';

  List<ScanResult> atDevices;
  List<BluetoothDevice> connectedAtDevices = [];

  void _toBlueVerifyScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      BlueVerifyScreen.routeName,
    );
  }

  void _toBlueConnectedScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      BlueConnectedScreen.routeName,
    );
  }

  void _connect(BuildContext context, int idx) {
    // print('Pressed');
    atDevices[idx].device.connect();
    Navigator.of(context).pushNamed(
      BlueConnectedScreen.routeName,);
  }

  List<ScanResult> getDiscoveredDevices() {
    return this.atDevices;
  }

  List<BluetoothDevice> getPairedDevices() {
    return this.connectedAtDevices;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: RaisedButton(
        color: Colors.grey,
        child: Text(
          'To connect page (test)',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => _toBlueConnectedScreen(context),
      ),
      appBar: AppBar(
        title: Text('Find Devices'),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              
              // StreamBuilder<List<BluetoothDevice>>(
              //   stream: Stream.periodic(Duration(seconds: 2))
              //       .asyncMap((_) => FlutterBlue.instance.connectedDevices),
              //   initialData: [],
              //   builder: (c, snapshot) => Column(
              //     children: snapshot.data?.map((d) => Container(
              //               decoration: BoxDecoration(color: Colors.black),
              //               child: ListTile(
              //                 title: Text(
              //                   d.name,
              //                   style: TextStyle(color: Colors.white),
              //                 ),
              //                 subtitle: Text(
              //                   d.id.toString(),
              //                   style: TextStyle(color: Colors.white),
              //                 ),
              //                 trailing: StreamBuilder<BluetoothDeviceState>(
              //                   stream: d.state,
              //                   initialData: BluetoothDeviceState.disconnected,
              //                   builder: (c, snapshotstate) {
              //                     if (snapshotstate.data ==
              //                         BluetoothDeviceState.connected) {
              //                       connectedAtDevices = snapshot.data;
              //                       return RaisedButton(
              //                         color: Colors.grey,
              //                         child: Text(
              //                           'OPEN',
              //                           style: TextStyle(color: Colors.white),
              //                         ),
              //                         onPressed: () =>
              //                             _toBlueVerifyScreen(context),
              //                         // onPressed: () => Navigator.of(context)
              //                         //     .push(MaterialPageRoute(
              //                         //         builder: (context) =>
              //                         //             DeviceScreen(device: d))),
              //                       );
              //                     }
              //                     return Text(
              //                       snapshot.data.toString(),
              //                       style: TextStyle(color: Colors.white),
              //                     );
              //                   },
              //                 ),
              //               ),
              //             ),)?.toList() ?? [],
              //   ),
              // ),
              StreamBuilder<List<ScanResult>>(
                  stream: FlutterBlue.instance.scanResults,
                  initialData: [],
                  builder: (c, snapshot) {
                    atDevices = snapshot.data
                        .where((r) => r.device.name.startsWith('AT.Wallet'))
                        .toList();
                    // atDevices.forEach((r) {
                    //   if (connectedAtDevices.length > 0 ) {
                    //     for (var i = 0; i < connectedAtDevices.length; i++) {
                    //       if( r.device.name == connectedAtDevices[i].name)
                    //       {
                    //         atDevices.remove(r);
                    //       };
                    //     }
                    //   }
                    // }  );
                    if (atDevices.length > 0) {
                      return Container(
                        height: 300,
                        child: ListView.builder(
                          itemBuilder: (ctx, idx) {
                            return InkWell(
                              child: ListTile(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      atDevices[idx].device.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(atDevices[idx].device.id.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                12) //Theme.of(context).textTheme.caption,
                                        )
                                  ],
                                ),
                                trailing: RaisedButton(
                                  child: Text('Connect'),
                                  color: Colors.grey,
                                  onPressed: () => _connect(context, idx),
                                ),
                              ),
                            );
                            // return ListTile(
                            //   title: Text('The name of device is ${atDevices[idx].device.name}', style: TextStyle(color: Colors.white),),
                            // );
                          },
                          itemCount: atDevices.length,
                        ),
                      );
                    } else {
                      return Text('Connecting');
                    }
                  }

                  // try ListView.builder(
                  //   itemBuilder: (ctx, idx) {
                  //     List<ScanResult> atDevices = snapshot.data.where((r) => r.device.name.startsWith('AT.Wallet'));
                  //     return ListTile(title: atDevices[],);
                  //   },
                  //   itemCount: snapshot.data.where((r) => r.device.name.startsWith('AT.Wallet')).length,
                  // )

                  // changed by listView
                  // builder: (c, snapshot) => Column(
                  //   children: snapshot.data
                  //       .map(
                  //         // if (true) {}
                  //         (r) => ScanResultTile(
                  //           result: r,
                  //           onTap: () =>
                  //           // {}
                  //           Navigator.of(context)
                  //               .push(MaterialPageRoute(builder: (context) {
                  //             r.device.connect();
                  //             return DeviceScreen(device: r.device);
                  //           })),
                  //         ),
                  //       )
                  //       .toList(),
                  // ),

                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.white54,
            );
          } else {
            return FloatingActionButton(
                backgroundColor: Colors.grey,
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}

// class DeviceScreen extends StatelessWidget {
//   const DeviceScreen({Key key, this.device}) : super(key: key);

//   final BluetoothDevice device;

//   List<int> _getRandomBytes() {
//     final math = Random();
//     return [
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255)
//     ];
//   }

//   List<Widget> _buildServiceTiles(List<BluetoothService> services) {
//     return services
//         .map(
//           (s) => ServiceTile(
//             service: s,
//             characteristicTiles: s.characteristics
//                 .map(
//                   (c) => CharacteristicTile(
//                     characteristic: c,
//                     onReadPressed: () => c.read(),
//                     onWritePressed: () => c.write(_getRandomBytes()),
//                     onNotificationPressed: () =>
//                         c.setNotifyValue(!c.isNotifying),
//                     descriptorTiles: c.descriptors
//                         .map(
//                           (d) => DescriptorTile(
//                             descriptor: d,
//                             onReadPressed: () => d.read(),
//                             onWritePressed: () => d.write(_getRandomBytes()),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 )
//                 .toList(),
//           ),
//         )
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(device.name),
//         actions: <Widget>[
//           StreamBuilder<BluetoothDeviceState>(
//             stream: device.state,
//             initialData: BluetoothDeviceState.connecting,
//             builder: (c, snapshot) {
//               VoidCallback onPressed;
//               String text;
//               switch (snapshot.data) {
//                 case BluetoothDeviceState.connected:
//                   onPressed = () => device.disconnect();
//                   text = 'DISCONNECT';
//                   break;
//                 case BluetoothDeviceState.disconnected:
//                   onPressed = () => device.connect();
//                   text = 'CONNECT';
//                   break;
//                 default:
//                   onPressed = null;
//                   text = snapshot.data.toString().substring(21).toUpperCase();
//                   break;
//               }
//               return FlatButton(
//                   onPressed: onPressed,
//                   child: Text(
//                     text,
//                     style: Theme.of(context)
//                         .primaryTextTheme
//                         .button
//                         .copyWith(color: Colors.white),
//                   ));
//             },
//           )
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(color: Colors.black),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               StreamBuilder<BluetoothDeviceState>(
//                 stream: device.state,
//                 initialData: BluetoothDeviceState.connecting,
//                 builder: (c, snapshot) => ListTile(
//                   leading: (snapshot.data == BluetoothDeviceState.connected)
//                       ? Icon(
//                           Icons.bluetooth_connected,
//                           color: Colors.white,
//                         )
//                       : Icon(
//                           Icons.bluetooth_disabled,
//                           color: Colors.white,
//                         ),
//                   title: Text(
//                     'Device is ${snapshot.data.toString().split('.')[1]}.',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   subtitle: Text(
//                     '${device.id}',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   trailing: StreamBuilder<bool>(
//                     stream: device.isDiscoveringServices,
//                     initialData: false,
//                     builder: (c, snapshot) => IndexedStack(
//                       index: snapshot.data ? 1 : 0,
//                       children: <Widget>[
//                         IconButton(
//                           color: Colors.white,
//                           icon: Icon(Icons.refresh),
//                           onPressed: () => device.discoverServices(),
//                         ),
//                         IconButton(
//                           color: Colors.white,
//                           icon: SizedBox(
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation(Colors.grey),
//                             ),
//                             width: 18.0,
//                             height: 18.0,
//                           ),
//                           onPressed: null,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               StreamBuilder<int>(
//                 stream: device.mtu,
//                 initialData: 0,
//                 builder: (c, snapshot) => ListTile(
//                   title: Text(
//                     'MTU Size',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   subtitle: Text(
//                     '${snapshot.data} bytes',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   trailing: IconButton(
//                     color: Colors.white,
//                     icon: Icon(Icons.edit),
//                     onPressed: () => device.requestMtu(223),
//                   ),
//                 ),
//               ),
//               StreamBuilder<List<BluetoothService>>(
//                 stream: device.services,
//                 initialData: [],
//                 builder: (c, snapshot) {
//                   return Column(
//                     children: _buildServiceTiles(snapshot.data),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
