import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/models/wallet_transaction.dart';
import 'package:wallet/provider/miner_fee.dart';
import '../provider/exchange_rate.dart';
import '../provider/sending.dart';
import '../provider/wallet_transactions.dart';
import '../provider/wallets.dart';
import './send_screen.dart';
import './receive_screen.dart';

class CurrencyScreen extends StatelessWidget {
  static const routeName = '/currency-screen';

  @override
  Widget build(BuildContext context) {
    final coinIdx = Provider.of<Sending>(context).coinIdx;
    final coinType = Provider.of<Sending>(context).coinType;
    var exchangeRate = Provider.of<ExchangeRate>(context);
    var displayedWallet = Provider.of<Wallets>(context).displayedWallet();
    final double coins =
        double.parse(displayedWallet.coins.split(" ").toList()[coinIdx]);
    var minerFee = Provider.of<MinerFee>(context);
    var wts = Provider.of<WalletTransactions>(context).walletTransactions;

    final rcv = wts
        .where((t) =>
            t.toAddr ==
            displayedWallet.coinAddresses.split(" ").toList()[coinIdx])
        .toList();
    final snd = wts
        .where((t) =>
            t.fromAddr ==
            displayedWallet.coinAddresses.split(" ").toList()[coinIdx])
        .toList();

    void pressReceive(BuildContext context) {
      Navigator.of(context).pushNamed(ReceiveScreen.routeName);
    }

    void pressSend(BuildContext context) {
      Navigator.of(context).pushNamed(SendScreen.routeName);
    }

    _transactionDialog(
        ctx, idx, List<WalletTransaction> wts, String rcvOrSndSign) {
      WalletTransaction t = wts[idx];

      showDialog(
          context: ctx,
          builder: (_) => AlertDialog(
                title: Text("Transaction Detail"),
                content: Container(
                    width: double.maxFinite,
                    child: ListView(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(15),
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(rcvOrSndSign),
                            Text(t.value.toString()),
                            Text(" "+coinType)
                          ],
                        )),
                        Divider(),
                        Text("Status"),
                        Text(t.status),
                        Divider(),
                        Text("Date"),
                        Text(t.date),
                        Divider(),
                        Text("From"),
                        Text(t.fromAddr),
                        Divider(),
                        Text("To"),
                        Text(t.toAddr),
                        Divider(),
                        Text("Miner fee"),
                        Text(minerFee.typeIs(coinType).toString()),
                        Divider(),
                        Text("Transaction Hash"),
                        Text(t.hash),
                      ],
                    )),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK")),
                ],
              ));
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
                          '~=\$ ${coins * exchangeRate.typeIs(coinType)} USD',
                        ),
                      ],
                    )),
                Divider(),
                Container(
                  constraints: BoxConstraints.expand(height: 30),
                  // height: 100,
                  child:
                      TabBar(tabs: [Tab(text: "Receive"), Tab(text: "send")]),
                  color: Colors.grey,
                ),
                Divider(),
                Container(
                  height: 350,
                  child: TabBarView(children: [
                    //
                    ListView.builder(
                      itemBuilder: (ctx, idx) {
                        return InkWell(
                          child: ListTile(
                            onTap: () => _transactionDialog(ctx, idx, rcv, "+"),
                            leading: Icon(Icons.monetization_on),
                            title: Text(coinType),
                            subtitle: Text(rcv[idx].fromAddr.length > 6
                                ? "${rcv[idx].fromAddr.substring(0, 6)}...${rcv[idx].fromAddr.substring(rcv[idx].fromAddr.length - 6)}"
                                : "${rcv[idx].fromAddr}"),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("+ ${rcv[idx].value} $coinType"),
                                Text(rcv[idx].date)
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: rcv.length,
                    ),
                    ListView.builder(
                      itemBuilder: (ctx, idx) {
                        return InkWell(
                          child: ListTile(
                            onTap: () => _transactionDialog(ctx, idx, snd, "-"),
                            leading: Icon(Icons.monetization_on),
                            title: Text(coinType),
                            subtitle: Text(snd[idx].toAddr.length > 6
                                ? "${snd[idx].toAddr.substring(0, 6)}...${snd[idx].toAddr.substring(rcv[idx].fromAddr.length - 6)}"
                                : "${snd[idx].toAddr}"),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text("- ${snd[idx].value} $coinType"),
                                Text(snd[idx].date),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snd.length,
                    ),
                  ]),
                )
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
