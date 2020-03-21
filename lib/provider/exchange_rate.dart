import 'package:flutter/material.dart';

class ExchangeRate with ChangeNotifier {
  Map<String, double> _ex = 
  {
  'Ethereum': 124.21,
  'USDT': 1.011,
  'Bitcoin': 8695.67,
  'Bitcoin Cash': 322.93,
  'Litecoin': 56.29,
  'Dogecoin': 0.00235465,
  'Dash': 119.77
};

void setExchangeRate(newEx) {
  _ex = newEx;
  notifyListeners();
}

double typeIs(String coinType){
  return _ex[coinType];
}
}