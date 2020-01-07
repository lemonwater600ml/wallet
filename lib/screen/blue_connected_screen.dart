import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import './blue_verify_screen.dart';

class BlueConnectedScreen extends StatelessWidget {
  static const routeName = 'blue-connected';
  List<BluetoothDevice> connectedAtDevices = [];

  void _toBlueVerifyScreen(BuildContext context) {
    Navigator.of(context).pushNamed(
      BlueVerifyScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Connected Devices'),
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: RaisedButton(
        color: Colors.grey,
        child: Text(
          'To connect page (test)',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => _toBlueVerifyScreen(context),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                          ?.map(
                            (d) => Container(
                              decoration: BoxDecoration(color: Colors.black),
                              child: ListTile(
                                title: Text(
                                  d.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  d.id.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: StreamBuilder<BluetoothDeviceState>(
                                  stream: d.state,
                                  initialData:
                                      BluetoothDeviceState.disconnected,
                                  builder: (c, snapshotstate) {
                                    if (snapshotstate.data ==
                                        BluetoothDeviceState.connected) {
                                      connectedAtDevices = snapshot.data;
                                      return RaisedButton(
                                        color: Colors.grey,
                                        child: Text(
                                          'OPEN',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () =>
                                            _toBlueVerifyScreen(context),
                                        // onPressed: () => Navigator.of(context)
                                        //     .push(MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             DeviceScreen(device: d))),
                                      );
                                    }
                                    return Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                          ?.toList() ??
                      [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
