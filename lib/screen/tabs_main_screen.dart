import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/provider/wallets.dart';
import '../models/wallet.dart';

import './create_wallet_screen.dart';
import './wallet_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// import '../main.dart';

// class WalletsIht extends InheritedWidget {
//   String displayedName;
//   final List<Wallet> wallets;
//   WalletsIht({Widget child, this.displayedName, this.wallets})
//       : super(child: child);

//   @override
//   bool updateShouldNotify(WalletsIht oldWidget) {
//     if (wallets != oldWidget.wallets ||
//         displayedName != oldWidget.displayedName) {
//       print('WalletsIht detected change!!!!');
//     }
//     return wallets != oldWidget.wallets ||
//         displayedName != oldWidget.displayedName;
//   }

//   static WalletsIht of(BuildContext context) =>
//       context.dependOnInheritedWidgetOfExactType();
// }

// class InheritedDisplayedName extends InheritedWidget {
//   final String displayedName;
//   InheritedDisplayedName({Widget child, this.displayedName})
//       : super(child: child);

//   @override
//   bool updateShouldNotify(InheritedDisplayedName oldWidget) {
//     if (displayedName != oldWidget.displayedName) {
//       print('InheritedDisplayedName detected change!!!!');
//     }
//     return displayedName != oldWidget.displayedName;
//   }

//   static InheritedDisplayedName of(BuildContext context) =>
//       context.dependOnInheritedWidgetOfExactType();
// }

class TabsMainScreen extends StatefulWidget {
  static const routeName = '/homepage';
  @override
  _TabsWalletScreenState createState() => _TabsWalletScreenState();
}

class _TabsWalletScreenState extends State<TabsMainScreen> {

  // WalletsIht ihtWallets;

  Future<Database> database;
  String displayedName;
  List<Wallet> wallets;
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

  Future<void> setDatabasePathAndOpen(String databaseName) async {
    final Future<Database> newDatabase =
        openDatabase(join(await getDatabasesPath(), databaseName));
    this.database = newDatabase;
    print('In TabsScreen: ====database opened===');
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
    // this.ihtWallets = WalletsIht(wallets: loadedWallets);
    this.wallets = loadedWallets;

    // print('In TabsScreen: Wallets.name in loadedWalletsFromInherited');
    // for (var i = 0; i < ihtWallets.wallets.length; i++) {
    //   print(ihtWallets.wallets[i].name.toString());
    // }
  }

  void exportWalletsToProvider(context, List<Wallet> wallets) {
    for (int i = 0; i < wallets.length; i++) {
    Provider.of<Wallets>(context).addWallet(wallets[i]);
    }
    
  }



  @override
  initState() {
    super.initState();
    if (walletsStream == null) {
      ////////////// Need to clean Dummy Data and create and empty homepage (empty wallet)
      // createDummyData().then((_) {
      //   setState(() {
      //     walletsStream = getWalletsStream();
      //   });
      //   print('In TabsScreen: createDummyData script done!');
      // });
      //
      setDatabasePathAndOpen('wallets').then((_) {
        setState(() {
          walletsStream = getWalletsStream();
        });
      });
      print(
          'In TabsScreen: "initStat" ask walletsStream from created DummyData');
    }
  }

  Widget build(BuildContext context) {
    print('In TabsScreen: Build run');
    
    return StreamBuilder<List<Wallet>>(
        stream: walletsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Loading data...'),
              ),
              // body: Text(data),
            );
          } else {
            exportWalletsToProvider(context, snapshot.data);
            displayedName = Provider.of<Wallets>(context).displayedName;
            wallets = Provider.of<Wallets>(context).wallets;
            print('In TabsScreen: Number of wallets: ${wallets.length}');
            // print('In TabsScreen: displayedName after check: $displayedName');

            return Scaffold(
              appBar: AppBar(
                title: Text('Wallet'),
                centerTitle: true,
              ),
              body: WalletScreen(),

              // body: WalletsIht(
              //   wallets: wallets,
              //   displayedName: displayedName,
              //   child: WalletScreen(),
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
                                  Provider.of<Wallets>(context).changeDisplayedName(wallets[idx].name);
                                  // displayedName = snapshot.data[idx].name;
                                });
                                print(
                                    'displayedName after tap: $displayedName');

                                Navigator.of(context).pop();
                              },
                              leading: Icon(Icons.lock_outline),
                              title: Text(
                                wallets[idx].name),
                                  // snapshot.data[idx]?.name ?? 'unknown name'),
                              trailing:
                                  Text(
                                    wallets[idx].id),
                                    // snapshot.data[idx]?.id ?? 'unknown id'),
                            ),
                          );
                        },
                        itemCount: wallets.length,
                        // itemCount: snapshot.data.length,
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
