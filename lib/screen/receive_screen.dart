import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wallet/provider/wallets.dart';

// import '../dummy_data.dart';

class ReceiveScreen extends StatelessWidget {
  static const routeName = '/receive-screen';
  @override
  Widget build(BuildContext context) {
    var displayedWallet = Provider.of<Wallets>(context).displayedWallet();
    
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
                  data: displayedWallet.mainAddress,
                  // data: selectedWallet.address,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: false,
                ),
              ),
            ),
            Center(child: Text('Address: ${displayedWallet.coinAddresses}'))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
