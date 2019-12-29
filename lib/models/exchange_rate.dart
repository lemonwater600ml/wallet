import 'dart:ffi';

import 'package:flutter/foundation.dart';

class ExchangeRate {
  final String currency;
  final double rate;
  
  ExchangeRate({
    @required this.currency, 
    @required this.rate,
  }
    
  );
}