import 'package:flutter/material.dart';
import '../models/wallet_transaction.dart';

class WalletTransactions with ChangeNotifier {
  List<WalletTransaction> _walletTransactions;

  List<WalletTransaction> get walletTransactions {
    return _walletTransactions?? [];
  }

  int get length {
    return _walletTransactions.length;
  }

  void addWalletTransaction(WalletTransaction walletTransaction) {
    _walletTransactions.add(walletTransaction);
    notifyListeners();
    
  }

  void updateWalletTransactions(List<WalletTransaction> walletTransactions){
    _walletTransactions = walletTransactions;
    // notifyListeners();
  }

}