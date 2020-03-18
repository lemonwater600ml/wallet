import 'dart:ffi';

import 'package:bitcoin_bip44/bitcoin_bip44.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:wallet/provider/wallet_transactions.dart';
import 'package:wallet/provider/wallets.dart';

import './send_screen.dart';
import './receive_screen.dart';
import '../dummy_data.dart';
import '../exchangerates.dart';

class CurrencyScreen extends StatelessWidget {
  static const routeName = '/currency-screen';

  @override
  Widget build(BuildContext context) {
    final coinIdx = ModalRoute.of(context).settings.arguments;
    var displayedWallet = Provider.of<Wallets>(context).displayedWallet();
    final double coins =
        double.parse(displayedWallet.coins.split(" ").toList()[coinIdx]);
    final coinType = displayedWallet.coinTypes.split(" ").toList()[coinIdx];

    // print("coins: $coins, coinType: $coinType");

    var walletTransactions =
        Provider.of<WalletTransactions>(context).walletTransactions;
    print("walletTransactions.length: ${walletTransactions.length}");

    final exchangeRate = EXCHANGERATES;
    // int currenciesIdx;
    // final selectedWalletIdx = 'ETH1';
    // final selectedWallet =
    //     DUMMY_WALLETS.firstWhere((wallet) => wallet.id == selectedWalletIdx);
    // final rcd = walletTransactions.where(
    //     (t) => t.to == displayedWallet.coins.split(" ").toList()[coinIdx]);
    // final snd = walletTransactions.where(
    //     (t) => t.from == displayedWallet.coins.split(" ").toList()[coinIdx]);
    final receivedRecords = TRANSACTIONS_RCV;
    final sendRecords = TRANSACTIONS_SND;

    void pressReceive(BuildContext context) {
      Navigator.of(context).pushNamed(ReceiveScreen.routeName);
    }

    void pressSend(BuildContext context) {
      Navigator.of(context).pushNamed(SendScreen.routeName);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Currency'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(15),
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          size: 50,
                        ),
                        Text(
                            'Total amount of ${displayedWallet.coinTypes.split(" ").toList()[coinIdx]} '),
                        Text(
                          '~=\$ ${coins * exchangeRate[coinType]} USD',
                        ),
                      ],
                    )),
                Divider(),

                // Container(
                //     constraints: BoxConstraints.expand(height: 30),
                //     // height: 100,
                //     child: TabBar(
                //         tabs: [Tab(text: "Receive"), Tab(text: "send")])),
                // Divider(),
                // Container(
                //   height: 350,
                //   child: TabBarView(children: [
                //     //
                //     ListView.builder(
                //       itemBuilder: (ctx, idx) {
                //         return InkWell(
                //           child: ListTile(
                //             onTap: () => {},
                //             leading: Icon(Icons.monetization_on),
                //             title: Text(receivedRecords[idx]['type']),
                //             subtitle: Text(
                //               '${receivedRecords[idx]['from'].toString().substring(1, 6)}...${receivedRecords[idx]['from'].toString().substring(receivedRecords[idx]['from'].toString().length - 6)}',
                //             ),
                //             trailing: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               children: <Widget>[
                //                 Text(
                //                   '+ ${receivedRecords[idx]['amount'].toString()} ${displayedWallet.coinTypes}',
                //                 ),
                //                 Text(receivedRecords[idx]['time'].toString()),
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //       itemCount: receivedRecords.length,
                //     ),
                //     ListView.builder(
                //       itemBuilder: (ctx, idx) {
                //         return InkWell(
                //           child: ListTile(
                //             onTap: () => {},
                //             leading: Icon(Icons.monetization_on),
                //             title: Text(sendRecords[idx]['type']),
                //             subtitle: Text(
                //               '${sendRecords[idx]['to'].toString().substring(1, 6)}...${sendRecords[idx]['to'].toString().substring(sendRecords[idx]['from'].toString().length - 6)}',
                //             ),
                //             trailing: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               children: <Widget>[
                //                 Text(
                //                   '- ${sendRecords[idx]['amount'].toString()} ${displayedWallet.coinTypes}',
                //                 ),
                //                 Text(sendRecords[idx]['time'].toString()),
                //               ],
                //             ),
                //           ),
                //         );
                //       },
                //       itemCount: sendRecords.length,
                //     ),
                //   ]),
                // )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          // color: Theme.of(context).primaryColorLight,
          child: ButtonBar(
        buttonMinWidth: 150,
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () => pressReceive(context),
              child: Text('Received')),
          RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () => pressSend(context),
              child: Text('Send'))
        ],
      )),
    );
  }
}
