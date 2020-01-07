import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bitcoin_bip44/bitcoin_bip44.dart' as bip44;
import 'package:flutter/material.dart';
import 'package:wallet/screen/create_wallet_check_screen.dart';

class CreateWalletScreen extends StatefulWidget {
  static const routeName = '/create-wallet';

  @override
  _CreateWalletScreenState createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends State<CreateWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  var mnemonic;
  int _methodIdx = 0;

  void _showCreateNewMethod(BuildContext context) {
    setState(() {
      _methodIdx = 1;
      Navigator.of(context).pop();
    });
  }

  void _showRecoverMethod(BuildContext context) {
    setState(() {
      _methodIdx = 2;
      Navigator.of(context).pop();
      
    });
  }

  void _addNewWalletToDevice(BuildContext context) {
    // Place holder for writing new wallet into device
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future get _localFile async {
    final path = await _localPath;
    return File('$path/wallet-info.dart');
  }

  Future writeCounter(int counter, String content) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(content);
  }

  Future readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If we encounter an error, return 0
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    void _recordWalletData(BuildContext context) {
      // Write the data into disk
      // Go to the wallet
    }
    // mnemonic = 'seed sock milk update focus rotate barely fade car face mechanic mercy';

    while ((mnemonic == null ) || (bip39.validateMnemonic(mnemonic) == false)) {
      mnemonic = bip39.generateMnemonic();
    }
    List<String> listMnemonic = mnemonic.split(" ");
    var seedHex = bip39.mnemonicToSeedHex(mnemonic);
    var seed = bip39.mnemonicToSeed(mnemonic);
    var bip44Wallet = bip44.Bip44(seedHex);

    TextFormField walletInfoField(String hint) {
      return TextFormField(
        decoration: InputDecoration(hintText: hint),
      );
    }

    void _toCreateWalletVarifyScreen(BuildContext context) {
      Navigator.of(context).pushNamed(
        CreateWalletCheckScreen.routeName,
      );
    }

    void _showWalletSelectDialog(BuildContext context) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
          content: Column(
            children: <Widget>[
              RadioListTile(title: Text('Create new wallet'),value: 'create new wallet', onChanged: (_)=>_showCreateNewMethod(context),),
            RadioListTile(title: Text('Recover wallet'),value: 'recover wallet', onChanged: (_)=>_showRecoverMethod(context),),
            ],
          ),
          actions: <Widget>[
            
            FlatButton(
              onPressed: ()  {Navigator.of(context).pop();},
              child: Text('OK'),
            )
          ],
        ),
      );
    }

    return Scaffold(
        bottomNavigationBar: RaisedButton(
          child: FlatButton(
              onPressed: () => _toCreateWalletVarifyScreen(context),
              child: Text('Next')),
          onPressed: () => _recordWalletData(context),
        ),
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
                  walletInfoField('Wallet name'),
                  TextFormField(
                    onTap: () => _showWalletSelectDialog(context),
                    decoration:
                        InputDecoration(hintText: 'Select initializing method'),
                  ),
                  // walletInfoField(),
                  
                  if (_methodIdx == 1)  // Create page
                  Column(
                    children: <Widget>[Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                        'Please write down all mnemonic phrases in sequential order'),
                  ),
                      Container(
                        child: ListView.builder(
                          itemBuilder: (ctx, idx) {
                            return Padding(
                                padding: EdgeInsets.all(2),
                                child: Text(
                                    '${(idx + 1).toString()}. ${listMnemonic[idx]}'));

                            // return ListTile(
                            //   leading: Text((idx + 1).toString()),
                            //   title: Text(listMnemonic[idx]),
                            //   contentPadding: EdgeInsets.all(0),
                            // );
                          },
                          itemCount: listMnemonic.length,
                        ),
                        height: 250,
                      ),
                    ],
                  ) 
                  else if (_methodIdx == 2) Container(
                    height: 250,
                    child: TextFormField(decoration: InputDecoration(hintText: 'Please type in your mnemonic'),),
                  )
                  ,
                  // RaisedButton(
                  //   onPressed: () => _addNewWalletToDevice(context),
                  //   child: Text('Create'),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}
