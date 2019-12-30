import 'package:flutter/material.dart';

import './send_screen.dart';
import './receive_screen.dart';
import '../dummy_data.dart';

// This can be passed from wallet_screen
class CurrencyScreen extends StatelessWidget {
  String fiatValueSum(currenciesCoinNumber, exchangeRate) {
    double sum = 0;
    currenciesCoinNumber.forEach(
      (map) {
        sum += exchangeRate[map['currency']] * map['coinNumber'];
      },
    );
    return sum.toString();
  }

  static const routeName = '/currency-screen';
  @override
  Widget build(BuildContext context) {
    // The following four variables can be passed from wallet_screen
    final exchangeRate = EXCHANGERATES;
    final selectedWalletIdx = 'eth1';
    final selectedWallet =
        DUMMY_WALLETS.firstWhere((wallet) => wallet.id == selectedWalletIdx);
    final receivedRecords = TRANSACTIONS_RCV;
    final sendRecords = TRANSACTIONS_SND;
    // final List<Map<String, Object>> receivedRecords = TRANSACTIONS_RCV;
    // final List<Map<String, Object>> sendRecords = TRANSACTIONS_SND;

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
                //
                Container(
                  margin: EdgeInsets.all(15),
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 50,),
                        Text('Total amount in the wallet '),
                        Text(
                            '~=\$ ${fiatValueSum(selectedWallet.coinsNumber, exchangeRate)} USD',),
                        
                      ],
                    )),
                Divider(),

                Container(
                    constraints: BoxConstraints.expand(height: 30),
                    // height: 100,
                    child: TabBar(tabs: [
                      Tab(text: "Receive"),
                      Tab(text: "send"),
                    ])),
                Divider(),
                Container(
                  height: 350,
                  child: TabBarView(children: [
                    //
                    ListView.builder(
                      itemBuilder: (ctx, idx) {
                        return InkWell(
                          child: ListTile(
                            onTap: () => {},
                            leading: Icon(Icons.monetization_on),
                            title: Text(receivedRecords[idx]['type']),
                            subtitle: Text('${                              receivedRecords[idx]['from'].toString().substring(1, 6)}...${receivedRecords[idx]['from'].toString().substring(receivedRecords[idx]['from'].toString().length-6)}',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '+ ${receivedRecords[idx]['amount'].toString()} ${selectedWallet.type}',
                                ),
                                Text(receivedRecords[idx]['time'].toString()),
                                
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: receivedRecords.length,
                    ),
                    ListView.builder(
                      itemBuilder: (ctx, idx) {
                        return InkWell(
                          child: ListTile(
                            onTap: () => {},
                            leading: Icon(Icons.monetization_on),
                            title: Text(sendRecords[idx]['type']),
                            subtitle: Text('${                              sendRecords[idx]['to'].toString().substring(1, 6)}...${sendRecords[idx]['to'].toString().substring(sendRecords[idx]['from'].toString().length-6)}',
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '- ${sendRecords[idx]['amount'].toString()} ${selectedWallet.type}',
                                ),
                                Text(sendRecords[idx]['time'].toString()),
                                
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: sendRecords.length,
                    ),
                  ]),
                )
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
