import 'package:flutter/material.dart';

class Sending with ChangeNotifier{
  double _amount;
  String _fromAddr;
  String _toAddr;
  String _memo;
  int _coinIdx;
  String _coinType;

void setAmount(newAmount){
  _amount = newAmount;
  notifyListeners();
}

void setFromAddr(newFromAddr){
  _fromAddr = newFromAddr;
  notifyListeners();
}
void setToAddr(newToAddr){
  _toAddr = newToAddr;
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
void setCoinType(newCoinType){
  _coinType = newCoinType;
  notifyListeners();
}

double get amount {
  return _amount;
}
String get toAddr {
  return _toAddr;
}
String get memo {
  return _memo;
}
int get coinIdx {
  return _coinIdx;
}
String get coinType {
  return _coinType;
}
String get fromAddr{
  return _fromAddr;
}

}