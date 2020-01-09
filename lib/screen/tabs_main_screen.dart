import 'package:flutter/material.dart';
import 'package:wallet/dummy_data.dart';
import './create_wallet_screen.dart';

import './wallet_screen.dart';

class TabsMainScreen extends StatefulWidget {
  static const routeName = '/homepage';
  @override
  _TabsWalletScreenState createState() => _TabsWalletScreenState();
}

class _TabsWalletScreenState extends State<TabsMainScreen> {
  final wallets = DUMMY_WALLETS;
  final List<Map<String, Object>> _pages = [
    {
      'page': WalletScreen(),
      'title': 'Wallet',
    },

  ];

  int _selectedPageIndex = 0;

  void _selectedIndex(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _toCreateWalletScreen(BuildContext context) {
Navigator.of(context).pushNamed(
      CreateWalletScreen.routeName,
    ).then((onValue){ setState(){}});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        centerTitle: true,
      ),
      body: _pages[_selectedPageIndex]['page'],
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: null,
      //   backgroundColor: Theme.of(context).primaryColor,
      //   unselectedItemColor: Colors.grey,
      //   selectedItemColor: Theme.of(context).accentColor,
      //   currentIndex: _selectedPageIndex,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.attach_money),
      //       title: Text('Wallet'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.multiline_chart),
      //       title: Text('Market(X)'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.laptop_chromebook),
      //       title: Text('Browser(X)'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_balance_wallet),
      //       title: Text('My Profile(X)'),
      //     ),
      //   ],
      // ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 400
              ,
              child: ListView.builder(
                itemBuilder: (ctx, idx) {
                  return InkWell(
                    child: ListTile(
                      onTap: () {},
                      leading: Icon(Icons.lock_outline),
                      title: Text(wallets[idx].type),
                      trailing: Text(wallets[idx].id),
                    ),
                  );
                },
                itemCount: wallets.length,
              ),
            ),
          Expanded(child: Align(alignment: FractionalOffset.bottomCenter, child: IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () => _toCreateWalletScreen(context),)))],
        ),
      ),
    );
  }
}
