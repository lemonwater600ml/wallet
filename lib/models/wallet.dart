import 'package:flutter/foundation.dart';
class Wallet {
  final String name;
  final String id;
  final String mainType;
  final String mainAddress;
  final String createMethod;
  final mnemonic;
  final int mnemonicLength;
  final seed;
  final seedHex;
  final bip44Wallet;
  String coinTypes;  // coinTypes is a String zip with coins. and plit by space e.g., "Bitcoin Ethereum"
  String coinAddresses;
  String coins;      // coins is a String zip with coinTypes and split by space e.g.,  "0.2223 2"
  
// can create new table for trans record and search according to wallet name
// final TRANSACTIONS_SND = [
//   {
//     'id': "000001",
//     'type': 'ETH',
//     'tranType': 'Send',
//     'amount': '0.1',
//     'from': '000ethreceive000',
//     'to': '0xTe34Gder1234567890',
//     'time': DateTime.parse("2019-07-20 20:18:04Z"),
//     'minerFee': 0.00004,
//     'status': 'Completed!',
//     'confirmedNum': 645,
//   },

  Wallet({
    @required this.name,
    this.id, 
    this.mainType,
    this.mainAddress,
    this.createMethod,
    @required this.mnemonic,
    // @required this.mnemonicList,
    this.mnemonicLength = 12,
    @required this.seed,
    @required this.seedHex,
    @required this.bip44Wallet,
    this.coinTypes,
    this.coinAddresses,
    this.coins,
  });

  set setCoinTypes(String val) => coinTypes = val;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'mainType': mainType,
      'mainAddress': mainAddress,
      'createMethod': createMethod,
      'mnemonic': mnemonic,
      'seed': seed,
      'seedHex': seedHex,
      'bip44Wallet': bip44Wallet,
      'coinTypes': coinTypes,
      'coinAddresses': coinAddresses,
      'coins': coins,
    };
  }
}
