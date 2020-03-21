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

  void reduceCoin(int coinIdx, double reduceNum){
    print("In reduceCoin");
    Wallet w = _wallets.firstWhere((wallet) => wallet.name == _displayedName);
    List<String>coinList = w.coins.split(" ").toList();
    print("Original coins: ${w.coins}");
    coinList[coinIdx] = (double.parse(coinList[coinIdx]) - reduceNum).toString();
    w.coins = coinList.join(" ");
    print("Coins after change: ${w.coins}");
    notifyListeners();
  }
  void addCoin(int coinIdx, double addNum){
    Wallet w = _wallets.firstWhere((wallet) => wallet.name == _displayedName);
    List<String>coinList = w.coins.split(" ").toList();
    coinList[coinIdx] = (double.parse(coinList[coinIdx]) + addNum).toString();
    w.coins = coinList.join(" ");
    notifyListeners();
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