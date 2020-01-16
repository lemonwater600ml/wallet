import 'package:flutter/foundation.dart';

class Wallet {
  final String name;
  final String id;
  final String mainType;
  final String mainAddress;
  final String method;

  final mnemonic;
  // final List<String> mnemonicList;
  final int mnemonicLength;
  final seed;
  final seedHex;
  final bip44Wallet;
  String coinTypes;  // coinTypes is a String zip with coins. and plit by space e.g., "Bitcoin Ethereum"
  String coinAddresses;
  String coins;      // coins is a String zip with coinTypes and split by space e.g.,  "0.2223 2"

  Wallet({
    @required this.name,
    @required this.id, 
    this.mainType,
    this.mainAddress,
    @required this.method,
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
      'method': method,
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
