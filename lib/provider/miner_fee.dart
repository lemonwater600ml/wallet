import 'package:flutter/material.dart';

// provider only, no SQLite TABLE

class MinerFee with ChangeNotifier {
  Map<String, double> _minerFee = {
'Ethereum': 0.000021,
  'USDT': 0.001,
  'Bitcoin': 0.000001,
  'Bitcoin Cash': 0.0003,
  'Litecoin': 0.01,
  'Dogecoin': 1,
  'Dash': 0.001
  };

  double typeIs (String coinType){
    return _minerFee[coinType];
  }
  
  void setMinerFee (Map<String, double> newMinerFee) {
    _minerFee = newMinerFee;
    notifyListeners();
  }

}