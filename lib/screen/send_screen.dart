import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
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

   _toSendCheckScreen(_amount, _address, _memo, coinIdx){
        Navigator.of(context).pushNamed(SendCheckScreen.routeName,
        arguments: [_amount, _address, _memo, coinIdx]);
  }


  @override
  Widget build(BuildContext context) {
    double _amount;
    String _address;
    String _memo;
    int coinIdx = ModalRoute.of(context).settings.arguments;

    var displayedWallet = Provider.of<Wallets>(context).displayedWallet();
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
                          Text('${displayedWallet.coinTypes} amount'),
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
                              _amount = double.parse(value);
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
                              _address = value;
                            },
                          ),
                          // Text(scanResult),
                          Text('Memo'),
                          TextFormField(
                            decoration: InputDecoration.collapsed(
                                hintText: '(Optional)'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please a valid memo';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _memo = value;
                            },
                          ),
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
                            // If the form is valid, display a Snackbar.
                            
                            // Scaffold.of(super.context).showSnackBar(
                            //   SnackBar(
                            //     content: Text('Processing Data'),
                            //   ),
                            // );

                            _formKey.currentState.save();
                            print(
                                '_amount: $_amount; _address: $_address; _memot: $_memo');
                            _toSendCheckScreen(_amount, _address, _memo, coinIdx);
                            // _addTransaction(displayedWallet, _amount, _address, _memo);
                            

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
