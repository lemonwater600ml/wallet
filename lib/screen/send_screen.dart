import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:wallet/provider/sending.dart';
import 'package:wallet/provider/wallets.dart';
import 'package:wallet/screen/send_check_screen.dart';

import '../dummy_data.dart';

class SendScreen extends StatefulWidget {
  static const routeName = '/send-screen';

  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  TextEditingController _controller = TextEditingController(text: '');
  // String scanResult = '';
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Future scan() async {
    String scanResult = await scanner.scan();
    setState(() {
      // this.scanResult = scanResult;
      // print(this.scanResult);
      this._controller = TextEditingController(text: scanResult);
    });
  }

  _toSendCheckScreen() {
    Navigator.of(context).pushNamed(SendCheckScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var displayedWallet = Provider.of<Wallets>(context).displayedWallet();
    var sending = Provider.of<Sending>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Send'),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              '${displayedWallet.coinTypes.split(" ").toList()[sending.coinIdx]} amount'),
                          TextFormField(
                            decoration: InputDecoration.collapsed(
                                hintText: 'Please enter amount'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              sending.setAmount(double.parse(value));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('To'),
                              IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: scan,
                              ),
                            ],
                          ),
                          TextFormField(
                            // initialValue: scanResult.toString(),
                            controller: _controller,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Please enter an address'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              sending.setAddress(value);
                            },
                          ),
                          // Text(scanResult),
                          Text('Memo'),
                          TextFormField(
                            decoration: InputDecoration.collapsed(
                                hintText: '(Optional)'),
                            validator: (value) {
                              // if (value.isEmpty) {
                              //   return 'Please a valid memo';
                              // }
                              return null;
                            },
                            onSaved: (value) {
                              sending.setMemo(value);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text('Miner Fee'),
                          Text("1234"),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            _toSendCheckScreen();
                          }
                        },
                        child: Text('Next step',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
