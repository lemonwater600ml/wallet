import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import './tabs_main_screen.dart';
import 'tabs_main_screen.dart';
import '../models/wallet.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../provider/wallets.dart';

class CreateWalletCheckScreen extends StatelessWidget {
  static const routeName = '/create-wallet-check';
  final _formKey = GlobalKey<FormState>();
  List<String> _mnemonicList;
  
  Wallet newWallet;
  List<Wallet> wallets;
  Future<Database> database;
  // Map<String, dynamic> walletPropertiesMap = new Map<String, dynamic>();
  List<int> _answerIndexes = [
    2,
    5,
    8,
    11
  ]; // 3 => question 1; 6 => question 2; 9 and 12 for question 3

  // CreateWalletCheckScreen({@required this.walletProperties });

  void _writeNewWalletIntoCard() {
    // null interface
  }

  Future<void> setDatabasePathAndOpen(String databaseName) async {
    final Future<Database> newDatabase =
        openDatabase(join(await getDatabasesPath(), databaseName));
    this.database = newDatabase;
    print('In CreateWalletCheckScreen() ====database opened===');
  }

  Future<void> insertWallet(String tableName, Wallet wallet) async {
    final Database db = await database;
    await db.insert(
      tableName,
      wallet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('In CheckScreen, inserWallet completed');
  }

  Stream<List<Wallet>> getWalletsStream() async* {
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
    this.wallets = loadedWallets;
    yield loadedWallets;
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
    this.wallets = loadedWallets;
    return loadedWallets;
  }

  Widget _questionText(String text, var answer, var sumAnswer) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    newWallet = ModalRoute.of(context).settings.arguments;
    // walletProperties.mnemonic = '123';
    // print('Data get: ${ModalRoute.of(context).settings.arguments}');

    // test _mnemonicList
    // _mnemonicList = [
    //   '-1',
    //   '-2',
    //   '-3',
    //   '-4',
    //   '-5',
    //   '-6',
    //   '-7',
    //   '-8',
    //   '-9',
    //   '-10',
    //   '-11',
    //   '-12',
    // ];

    _mnemonicList = newWallet.mnemonic.toString().split(' ');
    return Scaffold(
      appBar: AppBar(
        title: Text('Initialize Wallet'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Text( walletPropertiesMap['walletName'], style: TextStyle(fontSize: 30), ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Check Mnemonic',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'To make sure the mnemonic phrases have been written down correctly, please answer the following questions.'),
                  ),
                  _questionText(
                      'What is the index number of "${_mnemonicList[_answerIndexes[0]]}"?',
                      _answerIndexes[0],
                      null),
                  TextFormField(
                    validator: (value) {
                      if (value.toString() !=
                          (_answerIndexes[0] + 1).toString()) {
                        return 'The answer is incorrect.';
                      }
                      return null;
                    },
                  ),
                  _questionText(
                      'What is the word at index number ${_answerIndexes[1]}?',
                      _answerIndexes[1],
                      null),
                  TextFormField(
                    validator: (value) {
                      if (value.toString() !=
                          _mnemonicList[(_answerIndexes[1] - 1)].toString()) {
                        return 'The answer is incorrect.';
                      }
                      return null;
                    },
                  ),
                  _questionText(
                      'What is the sum of the index number of "${_mnemonicList[_answerIndexes[2]]}" and "${_mnemonicList[_answerIndexes[3]]}"?',
                      _answerIndexes[2],
                      _answerIndexes[3]),
                  TextFormField(
                    validator: (value) {
                      if (value.toString() !=
                          (_answerIndexes[2] + _answerIndexes[3] + 2)
                              .toString()) {
                        return 'The answer is incorrect.';
                      }
                      return null;
                    },
                  ),

                  // Text('walletProperties? ${walletProperties == null}'  ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text('Back'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text('Next'),
            onPressed: () async {
              print('onPressed detected');
              if (_formKey.currentState.validate()) {
                print(
                    "In CreateWalletCheckScreen: validate completed, start open database");
                await setDatabasePathAndOpen('wallets');
                print("In CreateWalletCheckScreen: start inserting wallet");
                await insertWallet('wallets', this.newWallet);
                _writeNewWalletIntoCard();
                print('In CreateWalletCheckScreen: onPressed completed');
                var wallets = await getWallets();
                print('In CreateWalletCheckScreen: number of wallets in db: ${wallets.length}');
                Provider.of<Wallets>(context).updataWallets(wallets);
                // print('In CreateWalletCheckScreen: number of wallets in db: ${wallets.length}');
                Navigator.popUntil(
                    context, ModalRoute.withName(TabsMainScreen.routeName));
              }
            },
          )
        ],
      ),
    );
  }
}
