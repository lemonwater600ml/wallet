import 'package:flutter/material.dart';
import 'package:wallet/screen/currency_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../models/wallet.dart';
import '../dummy_data.dart';

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet';
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<Wallet> wallets = DUMMY_WALLETS;
  static const List<String> coinList = [
    'Bitcoin',
    'Bitcoin Cash',
    'Ethereum',
    'Litecoin',
    'Dogecoin',
    'Dash'
  ];
  String dropdownValue = coinList[0];
  List<Wallet> getWallets() {
    return this.wallets;
  }

  void _addCoinIntoWallet(BuildContext context, String coin) {
    // Waiting to add
  }

  String walletsStr;
//   void createWallet (String text) async {
//   final directory = await getApplicationDocumentsDirectory();
//   final file = File('${directory.path}/data.dart');
//   await file.writeAsString(text);
// }

  void selectCurrency(BuildContext context, num idx) {
    Navigator.of(context).pushNamed(CurrencyScreen.routeName, arguments: idx);
  }

  // Future<String> get _localPath async {
  // final directory = await getApplicationDocumentsDirectory();
  // // print('directory: ${directory.path}');
  // return directory.path;
// }

//   Future<File> get _localFile async {
//   final path = await _localPath;
//   print('path: $path');
//   return File('$path/wallets.txt');
// }

// Future<File> writeWallets(String contentStr) async {
//   final file = await _localFile;

//   // Write the file.
//   return file.writeAsString('$contentStr');
// }

// Future<String> readWallets() async {
//   // try {
//     final file = await _localFile;
//     print('file loading completed');
//     // Read the file.
//     print('file.path: ${file.path}');

//     String testWalletsStr = await file.readAsString();
//     print('walletsStr loading completed');
//     print('walletsStr: $testWalletsStr');
//     return testWalletsStr;
  // } catch (e) {
  //   // If encountering an error, return 0.
  //   return 'loading failed';
  // }
// }

  @override
  Widget build(BuildContext context) {
    final exchangeRate = EXCHANGERATES;
    final selectedWalletIdx = 'eth1';
    final selectedWallet =
        wallets.firstWhere((wallet) => wallet.id == selectedWalletIdx);

    String fiatValueSum(currenciesCoinNumber, exchangeRate) {
      double sum = 0;
      currenciesCoinNumber.forEach(
        (map) {
          sum += exchangeRate[map['currency']] * map['coinNumber'];
        },
      );
      return sum.toString();
    }

    String _calculateFiatValue(Map<String, Object> currentCoinNumber,
        Map<String, double> echangeRate) {
      var currency = currentCoinNumber['currency'];
      double result = exchangeRate[currency] * currentCoinNumber['coinNumber'];
      return result.toString();
    }

    void _showWalletSelectDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
          content: DropdownButton<String>(
            onChanged: (newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            value: dropdownValue,
            items: <String>[
              'Bitcoin',
              'Bitcoin Cash',
              'Ethereum',
              'Litecoin',
              'Dogecoin',
              'Dash'
            ].map<DropdownMenuItem<String>>(
              (String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              },
            ).toList(),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _addCoinIntoWallet(context, dropdownValue);
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        // Text('Test'),
        // RaisedButton(child: Text('Read and print'), onPressed: (){
        //     // readWallets();
        //     readWallets().then((value){
        //       setState(() {
        //         walletsStr = value;
        //       });
        //     });

        // },),
        // Text(walletsStr ?? 'faild to load'),
        // RaisedButton(child: Text('write'), onPressed: () {
        //   writeWallets('testString');
        // },),

        // Wallet Sum up
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          height: 100,
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${selectedWallet.type}-Wallet'),
                  Icon(Icons.more_horiz)
                ],
              ),
              Text(selectedWallet.address),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                      '\$ ${fiatValueSum(selectedWallet.coinsNumber, exchangeRate)}'),
                ],
              ),
            ],
          ),
        ),

        // Assets / Collectibles bar
        Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(10),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Assets '),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showWalletSelectDialog(context);
                },
              ),
            ],
          ),
        ),

        Container(
          height: 300,
          child: ListView.builder(
              itemBuilder: (ctx, idx) {
                return InkWell(
                  onTap: () => selectCurrency(context, idx),
                  child: ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text(selectedWallet.coinsNumber[idx]['currency']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(selectedWallet.coinsNumber[idx]['coinNumber']
                            .toString()),
                        // Text(
                        //     '\$ ${double.parse(selectedWallet.currenciesCoinNumber[idx]['coinNumber'].toString())}'),
                        Text(
                            '\$ ${_calculateFiatValue(selectedWallet.coinsNumber[idx], exchangeRate)}'),
                      ],
                    ),
                  ),
                );
              },
              itemCount: selectedWallet.coinsNumber.length),
        ),

        // RaisedButton(onPressed: () => createWallet('testWriting'),
        // child: Text('Write string!'),)
      ],
    );
  }
}
