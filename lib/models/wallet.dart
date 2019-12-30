import 'package:flutter/foundation.dart';


class Wallet {
 final String id;
 final String type;
 final String address;
 final List<Map<String, Object>> coinsNumber;
 

  const Wallet({
    @required this.id,
    @required this.type,
    @required this.address,
    @required this.coinsNumber,
    
  });
  
double toDouble(Object obj) {
  double obj_num = obj;
  return obj_num;
}

}

