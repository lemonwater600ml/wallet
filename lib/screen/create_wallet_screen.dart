import 'package:bip39/bip39.dart' as bip39;
import 'package:bitcoin_bip44/bitcoin_bip44.dart' as bip44;
import 'package:flutter/material.dart';
import '../models/wallet.dart';
import './create_wallet_check_screen.dart';
import './tabs_main_screen.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';

class CreateWalletScreen extends StatefulWidget {
  static const routeName = '/create-wallet';

  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  // Map<String, dynamic> walletPropertiesMap = new Map<String, dynamic>();
  Wallet newWallet;

  var mnemonic;
  int numMnemonic = 12;
  List<String> mnemonicList;
  var seed;
  var seedHex;
  var bip44Wallet;

  String _name;
  String _tempMethod;
  String _createMethod;

  List<String> methodList = [
    'Please select',
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
      _createMethod = _tempMethod;
    });
    Navigator.of(context).pop();
  }

  void _recoveryWalletToPhone(BuildContext context, String mnemonic, var seed) {
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
    // print('while creating: ${this.mnemonic}');
    // var a = WalletProperties(
    this.newWallet = Wallet(
      name: this._name,
      // id: ,
      // mainType: , ///
      // mainAddress: ,
      createMethod: this._createMethod,
      mnemonic: this.mnemonic,
      mnemonicLength: this.mnemonicList.length,
      seed: this.seed.toString(),
      seedHex: this.seedHex.toString(),
      bip44Wallet: this.bip44Wallet.toString(),
      // coinTypes: ,
      // coinAddresses: ,
      // coins: ,
    );

    //     @required this.name,
    // this.id,
    // this.mainType,
    // this.mainAddress,
    // this.createMethod,
    // @required this.mnemonic,
    // // @required this.mnemonicList,
    // this.mnemonicLength = 12,
    // @required this.seed,
    // @required this.seedHex,
    // @required this.bip44Wallet,
    // this.coinTypes,
    // this.coinAddresses,
    // this.coins,

    // print('=== walletProperties ===>');
    // print(walletProperties.mnemonic);
    // print(walletProperties.walletName);
    // print('<=== walletProperties ===');

    // walletPropertiesMap['name'] = this._name;
    // walletPropertiesMap['method'] = this._createMethod;
    // walletPropertiesMap['mnemonic'] = this.mnemonic;
    // walletPropertiesMap['mnemonicList'] = this.mnemonicList;
    // walletPropertiesMap['mnemonicLength'] = this.mnemonicList.length;
    // walletPropertiesMap['seed'] = this.seed;
    // walletPropertiesMap['seedHex'] = this.seedHex;
    // walletPropertiesMap['bip44Wallet'] = this.bip44Wallet;

    // print(walletPropertiesMap['walletName']);
  }

  void _showWalletSelectDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
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
          actions: <Widget>[
            FlatButton(
              onPressed: () => _setMethod(context, _tempMethod),
              child: Text('OK'),
            )
          ],
        );
      }),
    );
  }

  void _toCreateWalletCheckScreen(BuildContext context) {
    _createWalletProperties(context);
    // print(walletProperties.mnemonic.toString());
    // print('pass $walletPropertiesMap');
    Navigator.of(context)
        .pushNamed(CreateWalletCheckScreen.routeName, arguments: newWallet);
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
                    _name = name;
                  },

                  decoration: InputDecoration(hintText: 'Wallet name'),
                ),

                TextFormField(
                  controller: TextEditingController.fromValue(
                      TextEditingValue(text: _createMethod ?? '')),
                  // initialValue: _method,
                  onTap: () => _showWalletSelectDialog(context),
                  decoration:
                      InputDecoration(hintText: 'Select initializing method'),
                ),
                if (_createMethod == 'Create new wallet') // Create page
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
                                context, _name, mnemonic);

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
                else if (_createMethod == 'Recovery wallet')
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
          if (_createMethod == 'Recovery wallet') {
            _recoveryWalletToPhone(context, mnemonic, seed);
            Navigator.popUntil(
                context, ModalRoute.withName(TabsMainScreen.routeName));
          } else if (_createMethod == 'Create new wallet') {
            _toCreateWalletCheckScreen(context);
          }
        },
      ),
    );
  }
}
