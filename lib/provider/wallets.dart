import 'package:flutter/material.dart';

import '../models/wallet.dart';

class Wallets with ChangeNotifier {
  List<Wallet> _wallets = [];

  List<Wallet> get wallets {
    return [..._wallets];
  }

  void addWallet() {
    // _wallets.add(value);
    notifyListeners();
  }

}