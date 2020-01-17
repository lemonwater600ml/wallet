import 'package:flutter/material.dart';
import '../models/wallet.dart';

import './create_wallet_screen.dart';
import './wallet_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class InheritedDisplayedName extends InheritedWidget {
  final String displayedName;
  InheritedDisplayedName({Widget child, this.displayedName})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedDisplayedName oldWidget) =>
      displayedName != oldWidget.displayedName;
  // static InheritedDisplayedId of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();
  static InheritedDisplayedName of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedDisplayedName)
          as InheritedDisplayedName;
}

class TabsMainScreen extends StatefulWidget {
  static const routeName = '/homepage';
  @override
  _TabsWalletScreenState createState() => _TabsWalletScreenState();
}

class _TabsWalletScreenState extends State<TabsMainScreen> {
  Future<Database> database;
  String displayedName;
  Stream<List<Wallet>> walletsStream;
  Wallet displayedWallet;

  // final List<Map<String, Object>> _pages = [
  //   {
  //     'page': WalletScreen(),
  //     'title': 'Wallet',
  //   },
  // ];

  // int _selectedPageIndex = 0;

  // void _selectedIndex(int index) {
  //   setState(() {
  //     _selectedPageIndex = index;
  //   });
  // }

  void _toCreateWalletScreen(BuildContext context) {
    Navigator.of(context)
        .pushNamed(
      CreateWalletScreen.routeName,
    )
        .then((onValue) {
      // setState() {}
    });
  }

  Future<void> createDummyData() async {
    final dummyWallets = [
      Wallet(
        name: 'test1',
        id: 'ETH1',
        mainAddress: '0xTe34Gder1234567890',
        mainType: 'ETH',
        createMethod: 'Recovery wallet',
        mnemonic: '-1 -2 -3 -4',
        mnemonicLength: 12,
        seed: 'testSeed',
        seedHex: 'testSeedHex',
        bip44Wallet: 'testBip44Wallet',
        coinTypes: 'Ethereum USDT',
        coinAddresses: 'testAdd1 testAdd2',
        coins: '16.7 5',
      ),
      Wallet(
        name: 'test2',
        id: 'BIT1',
        mainAddress: 'superBitCoinAddress',
        mainType: 'BIT',
        createMethod: 'Recovery wallet',
        mnemonic: '-1 -2 -3 -4',
        mnemonicLength: 12,
        seed: 'testSeed',
        seedHex: 'testSeedHex',
        bip44Wallet: 'testBip44Wallet',
        coinTypes: 'Bitcoin USDT',
        coinAddresses: 'testAdd1 testAdd2',
        coins: '0.5 5',
      ),
    ];

    await createDatabase('wallets');
    for (var i = 0; i < dummyWallets.length; i++) {
      await insertWallet('wallets', dummyWallets[i]);
    }
  }

  Future<void> createDatabase(String databaseName) async {
    final Future<Database> newDatabase = openDatabase(
        join(await getDatabasesPath(), databaseName), onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE wallets (name TEXT PRIMARY KEY, id TEXT, mainType TEXT, mainAddress TEXT, createMethod TEXT, mnemonic TEXT, seed TEXT, seedHex TEXT, bip44Wallet TEXT, coinTypes TEXT, coinAddresses TEXT, coins TEXT)",
      );
    }, version: 1);
    this.database = newDatabase;
    print('====database created===');
  }

  Future<void> insertWallet(String tableName, Wallet wallet) async {
    final Database db = await database;
    await db.insert(
      tableName,
      wallet.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Stream<List<Wallet>> getWalletsStream() async* {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('wallets');

    List<Wallet> loadedWallets = List.generate(maps.length, (i) {
      return Wallet(
        name: maps[i]['name'],
        id: maps[i]['id'],
        mainType: maps[i]['mainType'],
        mainAddress: maps[i]['mainAddress'],
        createMethod: maps[i]['createMethod'],
        mnemonic: maps[i]['mnemonic'],
        mnemonicLength: maps[i]['mnemonicLength'],
        seed: maps[i]['seed'],
        seedHex: maps[i]['seedHex'],
        bip44Wallet: maps[i]['bip44Wallet'],
        coinTypes: maps[i]['coinTypes'],
        coinAddresses: maps[i]['coinAddresses'],
        coins: maps[i]['coins'],
      );
    });
    yield loadedWallets;
  }

  @override
  initState() {
    super.initState();
    if (walletsStream == null) {
      //////////////////// Need to clean Dummy Data and create and empty homepage (empty wallet)
      // createDummyData().then((_) {
      //   setState(() {
      //     walletsStream = getWalletsStream();
      //   });
      // });
      // print('In TabsScreen: DummyData created!');
    }
  }

  Widget build(BuildContext context) {
    print('In TabsScreen: Build run');
    return StreamBuilder<List<Wallet>>(
        stream: walletsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            createDummyData().then((_) {
              setState(() {
                walletsStream = getWalletsStream();
              });
            });
            return Scaffold(
              appBar: AppBar(
                title: Text('Loading data...'),
              ),
              // body: Text(data),
            );
          } else {
            displayedName ??= snapshot.data[0].name;
            print('In TabsScreen: Number of wallets: ${snapshot.data.length}');
            print('In TabsScreen: displayedName after check: $displayedName');

            return Scaffold(
              appBar: AppBar(
                title: Text('Wallet'),
                centerTitle: true,
              ),

              body: InheritedDisplayedName(
                displayedName: displayedName,
                child: WalletScreen(),
              ),
              // body: _pages[_selectedPageIndex]['page'],
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
                      height: 400,
                      child: ListView.builder(
                        itemBuilder: (ctx, idx) {
                          return InkWell(
                            child: ListTile(
                              onTap: () {
                                print(
                                    'displayedName before tap: ${displayedName}');

                                setState(() {
                                  displayedName = snapshot.data[idx].name;
                                });
                                print(
                                    'displayedName after tap: $displayedName');
                                Navigator.of(context).pop();
                              },
                              leading: Icon(Icons.lock_outline),
                              title: Text(snapshot.data[idx]?.name?? 'unknown name'),
                              trailing: Text(snapshot.data[idx]?.id?? 'unknown id'),
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
                      ),
                    ),
                    Expanded(
                        child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () => _toCreateWalletScreen(context),
                            )))
                  ],
                ),
              ),
            );
          }
        });
  }
}
