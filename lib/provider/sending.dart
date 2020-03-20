// TODO Implement this library.

import 'package:flutter/material.dart';

class Sending with ChangeNotifier{
  double _amount;
  String _address;
  String _memo;
  int _coinIdx;

void setAmount(newAmount){
  _amount = newAmount;
  notifyListeners();
}

void setAddress(newAddress){
  _address = newAddress;
  notifyListeners();
}

void setMemo(newMemo){
  _memo = newMemo;
  notifyListeners();
}
void setCoinIdx(newCoinIdx){
  _coinIdx = newCoinIdx;
  notifyListeners();
}

double get amount {
  return _amount;
}
String get address {
  return _address;
}
String get memo {
  return _memo;
}
int get coinIdx {
  return _coinIdx;
}


}