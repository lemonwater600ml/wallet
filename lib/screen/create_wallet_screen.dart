// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bitcoin_bip44/bitcoin_bip44.dart' as bip44;
import 'package:flutter/material.dart';
import '../models/wallet.dart';
import './create_wallet_check_screen.dart';

import 'dart:async';

import 'package:sqflite/sqflite.dart';

class CreateWalletScreen extends StatefulWidget {
  static const routeName = '/create-wallet';

  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> walletPropertiesMap = new Map<String, dynamic>();
  Wallet wallet;

  var mnemonic;
  int numMnemonic = 12;
  List<String> mnemonicList;
  var seed;
  var seedHex;
  var bip44Wallet;

  String _walletName;
  String _tempMethod;
  String _method;

  List<String> methodList = [
    'Please select method',
    'Create new wallet',
    'Recovery wallet'
  ];

//   final Future<Database> database = openDatabase(
//   join(await getDatabasesPath(), 'wallet_database.db'),
//   onCreate: (db, version) {
//     return db.execute(
//       "CREATE TABLE wallets(walletName TEXT, method TEXT, mnemonic TEXT, seed TEXT, seedHex TEXT, bip44Wallet TEXT)",
//     );
//   }, version: 1
// );

  Future<Database> database;

  // void createDatabase(String databaseName) async {
  //   final Future<Database> database = openDatabase(
  //       join(await getDatabasesPath(), databaseName), onCreate: (db, version) {
  //     return db.execute(
  //       "CREATE TABLE wallets(walletName TEXT, method TEXT, mnemonic TEXT, seed TEXT, seedHex TEXT, bip44Wallet TEXT, coinTypes TEXT, coins TEXT)",
  //     );
  //   }, version: 1);
  //   this.database = database;
  //   return;
  // }

  void _setMethod(BuildContext context, String tempMethod) {
    setState(() {
      _method = _tempMethod;
    });
    Navigator.of(context).pop();
  }

  void _addNewWalletToDevice(BuildContext context, String mnemonic, var seed) {
    // Place holder for writing new wallet into device
  }

  void _createSeedSeedhexWalletobject(
      BuildContext context, walletName, mnemonic) {
    this.mnemonicList = mnemonic.split(" ");
    // print(listMnemonic);
    // print(listMnemonic.length);
    this.seed = bip39.mnemonicToSeed(mnemonic);
    this.seedHex = bip39.mnemonicToSeedHex(mnemonic);
    this.bip44Wallet = bip44.Bip44(seedHex);
  }

  void _createWalletProperties(BuildContext context) {
    print('while creating: ${this.mnemonic}');
    // var a = WalletProperties(
    this.wallet = Wallet(
        name: this._walletName,
        // id: this.id,
        method: this._method,
        mnemonic: this.mnemonic,
        // mnemonicList: this.mnemonicList,
        mnemonicLength: this.mnemonicList.length,
        seed: this.seed,
        seedHex: this.seedHex,
        bip44Wallet: this.bip44Wallet);
    // print('=== walletProperties ===>');
    // print(walletProperties.mnemonic);
    // print(walletProperties.walletName);
    // print('<=== walletProperties ===');

    walletPropertiesMap['walletName'] = this._walletName;
    walletPropertiesMap['method'] = this._method;
    walletPropertiesMap['mnemonic'] = this.mnemonic;
    walletPropertiesMap['mnemonicList'] = this.mnemonicList;
    walletPropertiesMap['mnemonicLength'] = this.mnemonicList.length;
    walletPropertiesMap['seed'] = this.seed;
    walletPropertiesMap['seedHex'] = this.seedHex;
    walletPropertiesMap['bip44Wallet'] = this.bip44Wallet;

    // print(walletPropertiesMap['walletName']);
  }

  void _showWalletSelectDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        content: DropdownButton(
          onChanged: (newValue) {
            setState(() {
              _tempMethod = newValue;
            });
          },
          value: _tempMethod,
          items: methodList.map<DropdownMenuItem<String>>(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
        ),
        // content: Column(
        //   children: <Widget>[
        //     RadioListTile<String>(
        //       title: Text('Create new wallet'),
        //       value: 'Create new wallet',
        //       groupValue: _tempMethod,
        //       activeColor: Colors.blue,
        //       onChanged: (value) {
        //         setState(() {
        //           _tempMethod = value;
        //         });
        //       },
        //     ),
        //     RadioListTile<String>(
        //       title: Text('Recovery wallet'),
        //       value: 'Recovery wallet',
        //       groupValue: _tempMethod,
        //       onChanged: (value) {
        //         setState(() {
        //           _tempMethod = value;
        //         });
        //       },
        //     ),
        //   ],
        // ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _setMethod(context, _tempMethod),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  void _toCreateWalletCheckScreen(BuildContext context) {
    _createWalletProperties(context);
    // print(walletProperties.mnemonic.toString());
    // print('pass $walletPropertiesMap');
    Navigator.of(context).pushNamed(CreateWalletCheckScreen.routeName,
        arguments: walletPropertiesMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initialize Wallet'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  // initialValue: _walletName,
                  onChanged: (name) {
                    _walletName = name;
                  },

                  decoration: InputDecoration(hintText: 'Wallet name'),
                ),

                TextFormField(
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: _method ?? '')),
                  // initialValue: _method,
                  onTap: () => _showWalletSelectDialog(context),
                  decoration:
                      InputDecoration(hintText: 'Select initializing method'),
                ),
                if (_method == 'Create new wallet') // Create page
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                            'Please write down all mnemonic phrases in sequential order'),
                      ),
                      Container(
                        child: ListView.builder(
                          itemBuilder: (ctx, idx) {
                            while ((mnemonic == null) ||
                                (bip39.validateMnemonic(mnemonic) == false)) {
                              mnemonic = bip39.generateMnemonic();
                            }
                            _createSeedSeedhexWalletobject(
                                context, _walletName, mnemonic);

                            return Padding(
                                padding: EdgeInsets.all(2),
                                child: Text(
                                    '${(idx + 1).toString()}. ${mnemonicList[idx]}'));
                          },
                          itemCount: numMnemonic,
                        ),
                        height: 250,
                      ),
                    ],
                  )
                else if (_method == 'Recovery wallet')
                  Container(
                    height: 250,
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Please type in your mnemonic'),
                      onSaved: (value) {
                        setState(() {
                          mnemonic = value;
                        });
                      },
                    ),
                  ),
                // Text('text'),
                // FlatButton(
                //     child: Text('createProperties'),
                //     onPressed: () {
                //       _createWalletProperties(context);
                //       print(walletProperties.mnemonic);
                //     })
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: RaisedButton(
        child: Text('Next'),
        onPressed: () {
          if (_method == 'Recovery wallet') {
            _addNewWalletToDevice(context, mnemonic, seed);
            Navigator.pop(context);
          } else if (_method == 'Create new wallet') {
            _toCreateWalletCheckScreen(context);
          }
        },
      ),
    );
  }
}
