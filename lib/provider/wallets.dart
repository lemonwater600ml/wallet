import 'package:flutter/material.dart';
import '../models/wallet.dart';

class Wallets with ChangeNotifier {
  String _displayedName;
  List<Wallet> _wallets = [];

  String get displayedName {
    return _displayedName;
  }

  List<Wallet> get wallets {
    return [..._wallets];
  }

  int get length {
    return _wallets.length;
  }

  Wallet findByName(String displayedName) {
    return _wallets.firstWhere((wallet) => wallet.name == displayedName);
  }

  Wallet displayedWallet(){
    _displayedName ??= _wallets[0].name;
    return _wallets.firstWhere((wallet) => wallet.name == _displayedName);
  }

  void addWallet(Wallet newWallet) {
    _wallets.add(newWallet);
    notifyListeners();
  }

  void changeDisplayedName(String newDisplayedName) {
    _displayedName = newDisplayedName;
    notifyListeners();
  }

  void updataWallets(List<Wallet> newWallets) {
    _wallets = newWallets;
    // notifyListeners();
  }

}