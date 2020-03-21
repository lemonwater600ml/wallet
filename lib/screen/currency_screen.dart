import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    // final coinIdx = ModalRoute.of(context).settings.arguments;
    final coinIdx = Provider.of<Sending>(context).coinIdx;
    // final coinType = displayedWallet.coinTypes.split(" ").toList()[coinIdx];
    final coinType = Provider.of<Sending>(context).coinType;
    var exchangeRate = Provider.of<ExchangeRate>(context);
    var displayedWallet = Provider.of<Wallets>(context).displayedWallet();
    final double coins =
        double.parse(displayedWallet.coins.split(" ").toList()[coinIdx]);
    var wts = Provider.of<WalletTransactions>(context).walletTransactions;

    // final exchangeRate = EXCHANGERATES;

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
                          // TODO dialog detail of transactions
                          child: ListTile(
                            onTap: () => {},
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
                            onTap: () => {},
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
