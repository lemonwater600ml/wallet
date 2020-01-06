import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bitcoin_bip44/bitcoin_bip44.dart' as bip44;
import 'package:flutter/material.dart';

class CreateWalletScreen extends StatelessWidget {
  static const routeName = '/create-wallet';
  final _formKey = GlobalKey<FormState>();
  var mnemonic = bip39.generateMnemonic();

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

    while (bip39.validateMnemonic(mnemonic) == false) {
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

    return Scaffold(
        bottomNavigationBar: RaisedButton(
          child: Text('Create wallet'),
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
                  walletInfoField('Create new wallet'),
                  walletInfoField('Language'),
                  walletInfoField('Number'),
                  Padding(
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
