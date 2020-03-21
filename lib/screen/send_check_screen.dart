import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallet/models/wallet_transaction.dart';
import 'package:wallet/provider/wallet_transactions.dart';
import '../provider/exchange_rate.dart';
import '../provider/miner_fee.dart';
import '../provider/sending.dart';
import '../provider/wallets.dart';
import './send_complete_screen.dart';

class SendCheckScreen extends StatelessWidget {
  static const routeName = "/send-check-scree";

  void _confirmDialog(context, sending, minerFee, wts, wallets) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
              content:
                  Text("Are you sure to transfer money out of your wallet?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                FlatButton(
                    onPressed: () {
                      // add transactions into provider & sqlite
                      _addTransaction(sending, minerFee, wts);
                      
                      // TODO wallets provider & sqlite
                      _updateWallets(sending, wallets);
                      
                      Navigator.of(context)
                          .pushNamed(SendCompleteScreen.routeName);
                    },
                    child: Text("OK"))
              ],
            ));
  }

  void _addTransaction(
      Sending sending, MinerFee minerFee, WalletTransactions wts) {
    // prepare transaction data
    WalletTransaction wt = WalletTransaction(
      chain: "dummychain" + Random().nextInt(100).toString(),
      status: "dummystatus" + Random().nextInt(100).toString(),
      idx: Random().nextInt(100),
      hash: "dummyhash" + Random().nextInt(100).toString(),
      value: sending.amount,
      from_acc: sending.fromAddr,
      to_acc: sending.toAddr,
      date: "dummydate" + Random().nextInt(100).toString(),
      datetime: "dummydatetime" + Random().nextInt(100).toString(),
      timestamp: Random().nextInt(100),
      block_hash: "dummyblock_has" + Random().nextInt(100).toString(),
      block_number: Random().nextInt(100),
      gas: Random().nextInt(100),
      gas_price: minerFee.typeIs(sending.coinType),
      gas_used: Random().nextInt(100),
      nonce: 0,
      confirmations: Random().nextInt(100),
      token_transfers:
          "dummytoken_transfers" + Random().nextInt(100).toString(),
      input: "dummyinput" + Random().nextInt(100).toString(),
      walletId: "dummywalletId",
      coinIdx: sending.coinIdx,
    );

    // add to provider
    wts.addWalletTransaction(wt);
    print("In SendCheckScreen: add to provider complete.");
    // add to sqlite
    _addTransactionIntoSqlite(wt);
    print("In SendCheckScreen: add to sql complete.");
  }

 

  Future<void> _addTransactionIntoSqlite(WalletTransaction wt) async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), 'wallets'),
    );
    await db.insert('transactions', wt.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);

    }

  void _updateWallets(Sending sending, Wallets wallets){
    wallets.reduceCoin(sending.coinIdx, sending.amount);
    _updateWalletsSqlite(sending, wallets, wallets.displayedWallet().coins);
  }
  
  Future<void> _updateWalletsSqlite(Sending sending, Wallets wallets, String newCoins) async {
    Database db = await openDatabase(join(await getDatabasesPath(), 'wallets'),);
    
    await db.update('wallets', {'coins' : newCoins}, where: "id = ?" ,whereArgs: [wallets.displayedWallet().id]);
  }
  
  @override
  Widget build(BuildContext context) {
    var displayedWallet = Provider.of<Wallets>(context).displayedWallet();
    var sending = Provider.of<Sending>(context);
    var minerFee = Provider.of<MinerFee>(context);
    var exchangeRate = Provider.of<ExchangeRate>(context);
    var wallets = Provider.of<Wallets>(context);
    var wts = Provider.of<WalletTransactions>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Send preview'),
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
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        _confirmDialog(context, sending, minerFee, wts, wallets);
                      },
                      child: Text('Conform',
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
