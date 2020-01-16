import 'package:flutter/material.dart';
import 'package:wallet/screen/currency_screen.dart';

import '../exchangerates.dart';

import 'dart:async';
import '../models/wallet.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/////////// Display dashboard ///////////
// Upper block title: Text('${displayedWallet.mainType}-Wallet')
//
// Upper block detail
//
// Upper block address: Text(displayedWallet.mainAddress),
// Upper block sum: '\$ ${fiatValueSum(displayedWallet.coinTypes, displayedWallet.coins, exchangeRate).toString()}'),
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
  List<Wallet> wallets;
  Wallet displayedWallet;

  Future<void> createDummyData() async {
    final dummyWallet = Wallet(
      name: 'testWallet',
      id: 'ETH1',
      mainAddress: '0xTe34Gder1234567890',
      mainType: 'ETH',
      method: 'Recovery wallet',
      mnemonic: '-1 -2 -3 -4',
      mnemonicLength: 12,
      seed: 'testSeed',
      seedHex: 'testSeedHex',
      bip44Wallet: 'testBip44Wallet',
      coinTypes: 'Ethereum USDT',
      coinAddresses: 'testAdd1 testAdd2',
      coins: '16.7 5',
    );

    await createDatabase('wallets');
    await insertWallet('wallets', dummyWallet);
  }

  Future<void> createDatabase(String databaseName) async {
    
    final Future<Database> newDatabase = openDatabase(
        join(await getDatabasesPath(), databaseName), onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE wallets (name TEXT PRIMARY KEY, id TEXT, mainType TEXT, mainAddress TEXT, method TEXT, mnemonic TEXT, seed TEXT, seedHex TEXT, bip44Wallet TEXT, coinTypes TEXT, coinAddresses TEXT, coins TEXT)",
      );
    }, version: 1);
    this.database = newDatabase;
    print('====database created===');
  }

  Future<void> insertWallet(String tableName, Wallet wallet) async {
    final Database db = await database;
    await db.insert(
      tableName,
      wallet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Wallet>> getWallets() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('wallets');
    
    List<Wallet> loadedWallets = List.generate(maps.length, (i) {
      return Wallet(
        name: maps[i]['name'],
        id: maps[i]['id'],
        mainType: maps[i]['mainType'],
        mainAddress: maps[i]['mainAddress'],
        method: maps[i]['method'],
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
    this.wallets = loadedWallets;
    return loadedWallets;
  }

  Future<void> _updateWallet(BuildContext context, String tableName, Wallet newDisplayedWallet) async {
    final Database db = await database;
    // print('newDisplayedWallet.coinTypes: ${newDisplayedWallet.coinTypes}');
    await db.update(tableName, newDisplayedWallet.toMap(), where: 'id = ?', whereArgs: [newDisplayedWallet.id]);
  }

  void selectCurrency(BuildContext context, num idx) {
    Navigator.of(context).pushNamed(CurrencyScreen.routeName, arguments: idx);
  }

  @override
  initState(){
      super.initState();
      if (wallets == null) {
      createDummyData().then((_){
        setState(() {
          getWallets();
        });
      });
      
      } 
      // getWallets();
    }
  Widget build(BuildContext context) { 
    
    if (wallets == null ) {getWallets();}
    
    final exchangeRate = EXCHANGERATES;
    final displayedId = 'ETH1';
    final displayedWallet =
        wallets.firstWhere((wallet) => wallet.id == displayedId);

    double fiatValueSum(String coinTypes, String coins, exchangeRate) {
      double sum = 0;
      List<String> coinTypesList = coinTypes.split(' ');
      List<String> coinsList = coins.split(' ');
      for (var i = 0; i < coinTypesList.length; i++) {
        sum += exchangeRate[coinTypesList[i]] * double.parse(coinsList[i]);
      }
      return sum;
    }

      double _fiatValue(String coinType, String coinNumber,
        Map<String, double> echangeRate) {
      var coinNumberDouble = double.parse(coinNumber);
      double result =  exchangeRate[coinType]*coinNumberDouble;
      return result;
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
                displayedWallet.coinTypes = displayedWallet.coinTypes + " " + dropdownValue;
                displayedWallet.coins = displayedWallet.coins + " " + "0";
                print('concat completed');
                print('displayedWallet.coinTypes: ${displayedWallet.coinTypes}');
                await _updateWallet(context, 'wallets', displayedWallet);
                Navigator.of(context).pop();
                setState(() {
                  this.displayedWallet = displayedWallet;
                });
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    }

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
                  Text('${displayedWallet.mainType}-Wallet'),
                  Icon(Icons.more_horiz)
                ],
              ),
              Text(displayedWallet.mainAddress),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '\$ ${fiatValueSum(displayedWallet.coinTypes, displayedWallet.coins, exchangeRate).toString()}',
                      // 'tttest',
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
                    title: Text(displayedWallet.coinTypes.split(' ')[idx]),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(displayedWallet.coins.split(' ')[idx]),
                        // Text('\$ ${_calculateFiatValue(selectedWallet.coinsNumber[idx], exchangeRate)}'),
                        Text('\$ ${_fiatValue(displayedWallet.coinTypes.split(' ')[idx], displayedWallet.coins.split(' ')[idx] ,exchangeRate).toString()}'),
                      ],
                    ),
                  ),
                );
              },
              itemCount: displayedWallet.coinTypes.split(' ').length),
              
        ),

      ],
    );
  }
}
