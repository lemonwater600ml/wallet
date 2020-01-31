import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/wallets.dart';

import './screen/wallet_screen.dart';
import './screen/blue_connected_screen.dart';
import './screen/create_wallet_check_screen.dart';
import './screen/create_wallet_screen.dart';
import './screen/blue_verify_screen.dart';
import './screen/blue_screen.dart';
import './screen/send_screen.dart';
import './screen/currency_screen.dart';
import './screen/receive_screen.dart';
import './screen/tabs_main_screen.dart';

void main() => runApp(WalletApp());

class WalletApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (ctx) => Wallets(),
      child: MaterialApp(
        title: 'Wallet',
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        darkTheme: ThemeData.dark(),

        // initialRoute: '/bluetooth-screen',
        routes: {
          '/': (ctx) => FindDevicesScreen(),
          // '/': (ctx) => TabsMainScreen(),
          TabsMainScreen.routeName: (ctx) => TabsMainScreen(),
          CurrencyScreen.routeName: (ctx) => CurrencyScreen(),
          ReceiveScreen.routeName: (ctx) => ReceiveScreen(),
          SendScreen.routeName: (ctx) => SendScreen(),
          BlueVerifyScreen.routeName: (ctx) => BlueVerifyScreen(),
          CreateWalletScreen.routeName: (ctx) => CreateWalletScreen(),
          FindDevicesScreen.routeName: (ctx) => FindDevicesScreen(),
          CreateWalletCheckScreen.routeName: (ctx) => CreateWalletCheckScreen(),
          BlueConnectedScreen.routeName: (ctx) => BlueConnectedScreen(),
          WalletScreen.routeName: (ctx) => WalletScreen(),
        },
      ),
    );
  }
}
