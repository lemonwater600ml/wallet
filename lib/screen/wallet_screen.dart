import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import '../provider/exchange_rate.dart';
import '../provider/sending.dart';
import '../provider/wallets.dart';
import '../screen/currency_screen.dart';
import '../models/wallet.dart';

/////////// Display dashboard ///////////
// pending: overflow issue, wallet detail chart
// Wallet info title: Text('${displayedWallet.mainType}-Wallet')
// Wallet info detail
// Wallet info address: Text(displayedWallet.mainAddress),
// Wallet info sum: '\$ ${fiatValueSum(displayedWallet.coinTypes, displayedWallet.coins, exchangeRate).toString()}'),
// ListTile coin name: Text(displayedWallet.coinTypes.split(' ')[idx]),
// ListTile coin number: Text(displayedWallet.coins.split(' ')[idx].toString()),
// ListTile fiatValue:  Text('\$ ${_fiatValue(displayedWallet.coinTypes.split(' ')[idx], displayedWallet.coins.split(' ')[idx] ,exchangeRate)}'),
// Listtile itemCount: itemCount: displayedWallet.coinTypes.split(' ').length),

class WalletScreen extends StatefulWidget {
  static const routeName = '/wallet';
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  static const List<String> coinList = [
    'Bitcoin',
    'Bitcoin Cash',
    'Ethereum',
    'Litecoin',
    'Dogecoin',
    'Dash'
  ];

  String dropdownValue = coinList[0];
  Future<Database> database;
  Stream<List<Wallet>> walletsStream;
  Wallet displayedWallet;

  Future<void> setDatabasePathAndOpen(String databaseName) async {
    final Future<Database> newDatabase =
        openDatabase(join(await getDatabasesPath(), databaseName));
    this.database = newDatabase;
    print('In WalletScreen() ====database opened===');
  }

  Future<void> insertWallet(String tableName, Wallet wallet) async {
    final Database db = await database;
    await db.insert(
      tableName,
      wallet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Wallet>> getWalletsFromSQLite() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('wallets');

    List<Wallet> loadedWallets = List.generate(maps.length, (i) {
      return Wallet(
        name: maps[i]['name'],
        id: maps[i]['id'],
        mainType: maps[i]['mainType'],
        mainAddress: maps[i]['mainAddress'],
        createMethod: maps[i]['createMethod'],
        mnemonic: maps[i]['mnemonic'],
        mnemonicLength: maps[i]['mnemonicLength'],
        seed: maps[i]['seed'],
        seedHex: maps[i]['seedHex'],
        bip44Wallet: maps[i]['bip44Wallet'],
        coinTypes: maps[i]['coinTypes'],
        coinAddresses: maps[i]['coinAddresses'],
        coins: maps[i]['coins'],
      );
    });
    return loadedWallets;
  }

  Future<void> _updateWallet(
      BuildContext context, String tableName, Wallet newDisplayedWallet) async {
    final Database db = await database;
    await db.update(tableName, newDisplayedWallet.toMap(),
        where: 'name = ?', whereArgs: [newDisplayedWallet.name]);
    print('_updateWallet script completed!');
  }

  void selectCurrency(BuildContext context, num idx) {
    var sending = Provider.of<Sending>(context);
    sending.setCoinIdx(idx);
    sending.setCoinType(displayedWallet.coinTypes.split(" ")[idx]);
    sending.setFromAddr(displayedWallet.coinAddresses.split(" ")[idx]);
    Navigator.of(context).pushNamed(CurrencyScreen.routeName, arguments: idx);
  }

  @override
  initState() {
    super.initState();
    setDatabasePathAndOpen('wallets').then((_) {});
  }

  Widget build(BuildContext context) {
    var exchangeRate = Provider.of<ExchangeRate>(context);
    String fiatValueSum(String coinTypes, String coins, ExchangeRate exchangeRate) {
      if (coinTypes == null || coins == null || exchangeRate == null) {
        return '0';
      }
      double sum = 0;
      List<String> coinTypesList = coinTypes.split(' ');
      List<String> coinsList = coins.split(' ');
      for (var i = 0; i < coinTypesList.length; i++) {
        sum += exchangeRate.typeIs(coinTypesList[i]) * double.parse(coinsList[i]);
      }
      return sum.toString();
    }

    String _fiatValue(
        String coinType, String coinNumber,ExchangeRate echangeRate) {
      if (coinType == null || coinNumber == null || exchangeRate == null) {
        return 'unknown value';
      }

      var coinNumberDouble = double.parse(coinNumber);
      double result = exchangeRate.typeIs(coinType) * coinNumberDouble;
      return result.toString();
    }

    void _showWalletSelectDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: DropdownButton<String>(
              onChanged: (newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              value: dropdownValue,
              items: coinList.map<DropdownMenuItem<String>>(
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
                onPressed: () async {
                  if (displayedWallet.coinTypes == null) {
                    displayedWallet.coinTypes = dropdownValue;
                    displayedWallet.coins = "0";
                  } else {
                    displayedWallet.coinTypes =
                        displayedWallet.coinTypes + " " + dropdownValue;
                    displayedWallet.coins = displayedWallet.coins + " " + "0";
                  }
                  print('concat completed');
                  await _updateWallet(context, 'wallets', displayedWallet);
                  Provider.of<Wallets>(context)
                      .updataWallets(await getWalletsFromSQLite());
                  print('_updateWallet completed');
                  print('In _updateWallet Befroe setState');
                  super.setState(() {});
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        }),
      );
    }

    displayedWallet = Provider.of<Wallets>(context).displayedWallet();
    print(
        'In WalletScreen(): displayedWallet.coinTypes: ${displayedWallet.coinTypes}');
    print('In WalletScreen(): displayedWallet.coins: ${displayedWallet.coins}');

    return Column(
      children: <Widget>[
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
                  Text(
                      '${displayedWallet.mainType ?? 'unknown mainType'}-Wallet'),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      return showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Wallet information'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                    'Name: ${displayedWallet.name.toString() ?? 'unknown'}',
                                    overflow: TextOverflow.fade,
                                  ),
                                  Text(
                                    'Id: ${displayedWallet.id ?? 'unknown'}',
                                    overflow: TextOverflow.fade,
                                  ),
                                  Text(
                                    'Address: ${displayedWallet.mainAddress ?? 'unknown'}',
                                    overflow: TextOverflow.fade,
                                  ),
                                  Text(
                                    'Seed: ${displayedWallet.seed ?? 'unknown'}',
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              Text(
                displayedWallet.mainAddress ?? 'unknown address',
                overflow: TextOverflow.fade,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '\$ ${fiatValueSum(displayedWallet.coinTypes, displayedWallet.coins, exchangeRate)}',
                  ),
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
                    title:
                        Text(displayedWallet.coinTypes?.split(' ')[idx] ??
                            'unknow coinType'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(displayedWallet.coins?.split(' ')[idx] ??
                            'null value'),
                        Text(
                            '\$ ${_fiatValue(displayedWallet.coinTypes?.split(' ')[idx] ?? null, displayedWallet.coins?.split(' ')[idx] ?? null, exchangeRate)}'),
                      ],
                    ),
                  ),
                );
              },
              itemCount: displayedWallet.coinTypes?.split(' ')?.length ?? 0),
        ),
      ],
    );
  }
}
