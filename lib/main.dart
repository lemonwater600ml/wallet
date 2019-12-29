import 'package:flutter/material.dart';

import './screen/bluetooth_screen.dart';
import './screen/send_screen.dart';
import './screen/currency_screen.dart';
import './screen/receive_screen.dart';

import './screen/tabs_main_screen.dart';

void main() => runApp(WalletApp());

class WalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet',
      theme: ThemeData.dark(),
      // initialRoute: '/bluetooth-screen',
      routes: {
        '/': (ctx) => BluetoothScreen(),
        // '/': (ctx) => TabsMainScreen(),
        TabsMainScreen.routeName: (ctx) => TabsMainScreen(),
        CurrencyScreen.routeName: (ctx) => CurrencyScreen(),
        ReceiveScreen.routeName: (ctx) => ReceiveScreen(),
        SendScreen.routeName: (ctx) => SendScreen(),
        
      },
      
    );
  }
}