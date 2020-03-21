import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/provider/exchange_rate.dart';
import 'package:wallet/provider/miner_fee.dart';
import 'package:wallet/provider/sending.dart';
import 'package:wallet/screen/tabs_main_screen.dart';

class SendCompleteScreen extends StatelessWidget {
  static const routeName = "/send-complete-screen";
  
  @override
  Widget build(BuildContext context) {
    // var displayedWallet = Provider.of<Wallets>(context).displayedWallet();
    var sending = Provider.of<Sending>(context);
    var minerFee = Provider.of<MinerFee>(context);
    var exchangeRate = Provider.of<ExchangeRate>(context);
    // var wts = Provider.of<WalletTransactions>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction completed'),
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
                          'Amount',
                        ),
                        Text(
                            sending.amount.toString() + " " + sending.coinType),
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
                        Text('Send to'),
                        Text(sending.toAddr),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Miner Fee'),
                        Column(
                          children: <Widget>[
                            Text(
                              minerFee.typeIs(sending.coinType).toString() +
                                  " " +
                                  sending.coinType,
                            ),
                            Text(
                                "~= \$ ${minerFee.typeIs(sending.coinType) * exchangeRate.typeIs(sending.coinType)}")
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[Text("Transaction Successful!"),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            Navigator.popUntil(
                        context, ModalRoute.withName(TabsMainScreen.routeName));

                          },
                          child: Text('Back to main page',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
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