import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import './wallet_screen.dart';
import '../models/wallet\.dart';

class CreateWalletCheckScreen extends StatelessWidget {
  static const routeName = '/create-wallet-check';
  final _formKey = GlobalKey<FormState>();
  List<String> _mnemonicList;
  Wallet wallet;
  Map<String, dynamic> walletPropertiesMap = new Map<String, dynamic>();
  List<int> _answerIndexes = [
    2,
    5,
    8,
    11
  ]; // 3 => question 1; 6 => question 2; 9 and 12 for question 3

  // CreateWalletCheckScreen({@required this.walletProperties });

  void _sendWalletDateToDevice() {
    // null interface
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

//   Future<String> get _localPath async {
//   final directory = await getApplicationDocumentsDirectory();

//   return directory.path;
// }

// Future<File> get _localFile async {
//   final path = await _localPath;
//   return File('$path/../wallets.dart');
// }

// Future<File> writeCounter(int counter) async {
//   final file = await _localFile;

//   // Write the file.
//   return file.writeAsString('$counter');
// }

// Future<int> readCounter() async {
//   try {
//     final file = await _localFile;

//     // Read the file.
//     String contents = await file.readAsString();

//     return int.parse(contents);
//   } catch (e) {
//     // If encountering an error, return 0.
//     return 0;
//   }
// }

  @override
  Widget build(BuildContext context) {
    walletPropertiesMap = ModalRoute.of(context).settings.arguments;
    // walletProperties.mnemonic = '123';
    // print('Data get: ${ModalRoute.of(context).settings.arguments}');
    
    // test only
    _mnemonicList = [
      '-1',
      '-2',
      '-3',
      '-4',
      '-5',
      '-6',
      '-7',
      '-8',
      '-9',
      '-10',
      '-11',
      '-12',
    ];
        // test only
   _mnemonicList = walletPropertiesMap['mnemonicList'];
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Back'),
          ),
          FlatButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _sendWalletDateToDevice();
              }
              // Navigator.of(context)
              // .popUntil(ModalRoute.withName(WalletScreen.routeName));
            },
            child: Text('Next'),
          )
        ],
      ),
    );
  }
}
