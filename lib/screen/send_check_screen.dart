import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/provider/sending.dart';
import 'package:wallet/provider/wallets.dart';

class SendCheckScreen extends StatelessWidget {
  static const routeName = "/send-check-scree";

  _confirmDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
              content:
                  Text("Are you sure to transfer money out of your wallet?"),
              actions: <Widget>[
                FlatButton(onPressed: () {}, child: Text("Cancel")),
                FlatButton(onPressed: () {}, child: Text("OK"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var displayedWallet = Provider.of<Wallets>(context).displayedWallet();
    var sending = Provider.of<Sending>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Send checking'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                            '${displayedWallet.coinTypes.split(" ").toList()[sending.coinIdx]} amount'),
                        Text(sending.amount.toString()),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('To'),
                        Text(sending.address),
                        Text('Memo'),
                        Text(sending.memo),
                      ],
                    ),
                  ),
                ),
                // Card(
                //   child: Container(
                //     padding: EdgeInsets.all(15),
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: <Widget>[
                //         Text('Miner Fee'),
                //         Text(sending.memo),
                //       ],
                //     ),
                //   ),
                // ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _confirmDialog(context);
                      },
                      child: Text('Conform ',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
