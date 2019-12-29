import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../dummy_data.dart';

class ReceiveScreen extends StatelessWidget {
  // can be replaced by passing data
  final exchangeRate = EXCHANGERATES;
  final selectedWallet =
      DUMMY_WALLETS.firstWhere((wallet) => wallet.id == 'eth1');

  static const routeName = '/receive-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive'),
      ),
      body: Card(
        color: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(50),
              child: Center(
                child: QrImage(
                  backgroundColor: Colors.white,
                  data: selectedWallet.mainAddress,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: false,
                ),
              ),
            ),
            Center(child: Text('Address: ${selectedWallet.mainAddress}')),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          // color: Theme.of(context).primaryColor,
          child: ButtonBar(
        buttonMinWidth: 150,
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton.icon(
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.file_upload),
            label: Text('Share'),
          ),
          FlatButton.icon(
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.content_copy),
            label: Text('Copy'),
          ),
        ],
      )),
    );
  }
}
