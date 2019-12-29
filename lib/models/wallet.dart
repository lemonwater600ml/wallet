import 'package:flutter/foundation.dart';


class Wallet {
 final String id;
 final String mainCurrency;
 final String mainAddress;
 final List<Map<String, Object>> currenciesCoinNumber;
 

  const Wallet({
    @required this.id,
    @required this.mainCurrency,
    @required this.mainAddress,
    @required this.currenciesCoinNumber,
    
  });
  
double toDouble(Object obj) {
  double obj_num = obj;
  return obj_num;
}

}

