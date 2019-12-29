import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:wallet/dummy_data.dart';

// ##### hardcoded #####
// 
//  class not connected now
// need to fix to load from the file
//  
// ############


void selectCurrency(BuildContext context) {
  
}


class WalletCurrency extends StatelessWidget {
  final String currency;
  final double coinNumber;
  final double fiatMoneyValueSum = 0;

  WalletCurrency({
    @required this.currency,
    @required this.coinNumber,
    }
  );

  @override
  Widget build(BuildContext context) {
    
    // final exchangeRate = EXCHANGERATES.firstWhere(
    //   (currencyName) => currencyName == currency );
      
    return InkWell(
      onTap: () => selectCurrency(context),
      child: ListTile(
        leading: Icon(Icons.attach_money),
        title: Text('ETH-hardcode'),
        // title: Text(currency),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('coinNumber-hardcode'),
            Text('fiatMoneyValue-hardcode'),
            // Text(coinNumber.toString()),
            // Text('\$ ${(coinNumber * exchangeRate.rate).toString()}')
          ],
        ),
      )
    );
  }
}