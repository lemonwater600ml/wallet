import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet/provider/wallet_transactions.dart';
import '../models/wallet_transaction.dart';
import 'package:wallet/provider/wallets.dart';
import '../models/wallet.dart';

import './create_wallet_screen.dart';
import './wallet_screen.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
  List<WalletTransaction> walletTransactions;

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
        coinAddresses: '0xTe34Gder12345678900 0xTe34Gder12345678901',
        coins: '16.7 0',
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
        coinAddresses: 'superBitCoinAddress0 superBitCoinAddress1',
        coins: '0 0',
      ),
    ];

    final dummyTransactions = [
      WalletTransaction(
        // rec
        chain: 'chain1',
        status: 'completed',
        idx: 1,
        hash: '0xhash1',
        value: 3,
        fromAddr: '0xf3257b324df',
        toAddr: '0xTe34Gder12345678900',
        date: '2020-03-11 01:12:34 UTC',
        datetime: '2020-03-11 01:12:34 UTC',
        timestamp: 123456789,
        blockHash: '0x3241b34c324d',
        blockNumber: 123456,
        gas: 78910,
        gasPrice: 0.3,
        gasUsed: 10,
        nonce: 0,
        confirmations: 778,
        tokenTransfers: '',
        input: '0x',
        walletId: 'ETH1',
        coinIdx: 0,
      ),
      WalletTransaction(
        // rec
        chain: 'chain2',
        status: 'completed',
        idx: 2,
        hash: '0xhash2',
        value: 5,
        fromAddr: '0xf3257b324df',
        toAddr: '0xTe34Gder12345678900',
        date: '2020-03-12 01:12:34 UTC',
        datetime: '2020-03-12 01:12:34 UTC',
        timestamp: 123456789,
        blockHash: '0x3241b34c324d',
        blockNumber: 123456,
        gas: 78910,
        gasPrice: 0.3,
        gasUsed: 10,
        nonce: 0,
        confirmations: 778,
        tokenTransfers: '',
        input: '0x',
        walletId: 'ETH1',
        coinIdx: 0,
      ),
      WalletTransaction(
        // rec
        chain: 'chain3',
        status: 'completed',
        idx: 2,
        hash: '0xhash3',
        value: 7,
        fromAddr: '0xf3257b324df',
        toAddr: '0xTe34Gder12345678900',
        date: '2020-03-13 01:12:34 UTC',
        datetime: '2020-03-13 01:12:34 UTC',
        timestamp: 123456789,
        blockHash: '0x3241b34c324d',
        blockNumber: 123456,
        gas: 78910,
        gasPrice: 0.3,
        gasUsed: 10,
        nonce: 0,
        confirmations: 778,
        tokenTransfers: '',
        input: '0x',
        walletId: 'ETH1',
        coinIdx: 0,
      ),
      WalletTransaction(
        // rec
        chain: 'chain2',
        status: 'completed',
        idx: 4,
        hash: '0xhash4',
        value: 2,
        fromAddr: '0xf3257b324df',
        toAddr: '0xTe34Gder12345678900',
        date: '2020-03-14 01:12:34 UTC',
        datetime: '2020-03-14 01:12:34 UTC',
        timestamp: 123456789,
        blockHash: '0x3241b34c324d',
        blockNumber: 123456,
        gas: 78910,
        gasPrice: 0.3,
        gasUsed: 10,
        nonce: 0,
        confirmations: 778,
        tokenTransfers: '',
        input: '0x',
        walletId: 'ETH1',
        coinIdx: 0,
      ),
      WalletTransaction(
        // snd
        chain: 'chain5',
        status: 'completed',
        idx: 2,
        hash: '0xhash5',
        value: 0.1,
        fromAddr: '0xTe34Gder12345678900',
        toAddr: 'sendAdd1',
        date: '2020-03-16 01:12:34 UTC',
        datetime: '2020-03-16 01:12:34 UTC',
        timestamp: 123456789,
        blockHash: '0x3241b34c324d',
        blockNumber: 123456,
        gas: 78910,
        gasPrice: 0.3,
        gasUsed: 10,
        nonce: 0,
        confirmations: 778,
        tokenTransfers: '',
        input: '0x',
        walletId: 'ETH1',
        coinIdx: 0,
      ),
      WalletTransaction(
        chain: 'chain6',
        status: 'completed',
        idx: 2,
        hash: '0xhash6',
        value: 0.2,
        fromAddr: '0xTe34Gder12345678900',
        toAddr: 'sendAdd2',
        date: '2020-03-17 01:12:34 UTC',
        datetime: '2020-03-17 01:12:34 UTC',
        timestamp: 123456789,
        blockHash: '0x3241b34c324d',
        blockNumber: 123456,
        gas: 78910,
        gasPrice: 0.3,
        gasUsed: 10,
        nonce: 0,
        confirmations: 778,
        tokenTransfers: '',
        input: '0x',
        walletId: 'ETH1',
        coinIdx: 0,
      ),
    ];

    final Future<Database> newDatabase =
        openDatabase(join(await getDatabasesPath(), 'wallets'),
            onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE wallets (name TEXT PRIMARY KEY, id TEXT, mainType TEXT, mainAddress TEXT, createMethod TEXT, mnemonic TEXT, seed TEXT, seedHex TEXT, bip44Wallet TEXT, coinTypes TEXT, coinAddresses TEXT, coins TEXT)",
      );
      await db.execute(
        "CREATE TABLE transactions (chain TEXT, status TEXT, idx INTEGER, hash TEXT PRIMARY KEY, value REAL, fromAddr TEXT, toAddr TEXT, date TEXT, datetime TEXT, timestamp INTEGER, blockHash TEXT, blockNumber INTEGER, gas INTEGER, gasPrice REAL, gasUsed INTEGER, nonce INTEGER, confirmations INTEGER, tokenTransfers TEXT, input TEXT, walletId TEXT, coinIdx INTEGER)",
      );
    }, version: 1);

    this.database = newDatabase;
    print('====TABLE wallets created===');
    print('====TABLE transactions created===');

    Database db = await database;
    for (var i = 0; i < dummyWallets.length; i++) {
      await db.insert(
        'wallets',
        dummyWallets[i].toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // await insertWallet('wallets', dummyWallets[i]);
    }

    for (var i = 0; i < dummyTransactions.length; i++) {
      await db.insert('transactions', dummyTransactions[i].toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
          
    }
    print("dummyTransactions.length: ${dummyTransactions.length}");
    
  }

  Future<void> queryWalletTransactions(context) async {
    Database db = await database;
    final List<Map<String, dynamic>> m = await db.query('transactions');

    print("m.length: ${m.length}");

    List<WalletTransaction> loadedWTs = List.generate(m.length, (i) {
      return WalletTransaction(
        chain: m[i]['chain'],
        status: m[i]['status'],
        idx: m[i]['idx'],
        hash: m[i]['hash'],
        value: m[i]['value'],
        fromAddr: m[i]['fromAddr'],
        toAddr: m[i]['toAddr'],
        date: m[i]['date'],
        datetime: m[i]['datetime'],
        timestamp: m[i]['timestamp'],
        blockHash: m[i]['blockHash'],
        blockNumber: m[i]['blockNumber'],
        gas: m[i]['gas'],
        gasPrice: m[i]['gasPrice'],
        gasUsed: m[i]['gasUsed'],
        nonce: m[i]['nonce'],
        confirmations: m[i]['confirmations'],
        tokenTransfers: m[i]['tokenTransfers'],
        input: m[i]['input'],
        walletId: m[i]['walletId'],
        coinIdx: m[i]['coinIdx'],
      );
    });

    Provider.of<WalletTransactions>(context).updateWalletTransactions(loadedWTs);
    print("======In TabMainScreen: update WalletTransactions provider");
  }

  // Future<void> createDatabase(String databaseName) async {
  //   final Future<Database> newDatabase = openDatabase(
  //       join(await getDatabasesPath(), databaseName), onCreate: (db, version) {
  //     return db.execute(
  //       "CREATE TABLE wallets (name TEXT PRIMARY KEY, id TEXT, mainType TEXT, mainAddress TEXT, createMethod TEXT, mnemonic TEXT, seed TEXT, seedHex TEXT, bip44Wallet TEXT, coinTypes TEXT, coinAddresses TEXT, coins TEXT)",
  //     );
  //   }, version: 1);
  //   this.database = newDatabase;
  //   print('====database created===');
  // }

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

  @override
  initState() {
    super.initState();
    if (walletsStream == null) {
      ////////////// Need to clean Dummy Data and create and empty homepage (empty wallet)
      createDummyData().then((_) {
        setState(() {
          walletsStream = getWalletsStream();
        });
        print('In TabsScreen: createDummyData script done!');
      });

      setDatabasePathAndOpen('wallets').then((_) async {
        setState(() {
          walletsStream = getWalletsStream();
        });
      });
      // print(
      //     'In TabsScreen: "initStat" ask walletsStream from created DummyData');
    }
  }

  Widget build(BuildContext context) {
    walletsStream = getWalletsStream();
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
            Provider.of<Wallets>(context).updataWallets(snapshot.data);
            wallets = Provider.of<Wallets>(context).wallets;
            queryWalletTransactions(context);

            print(
                'In TabsScreen StreamBuilder: Number of wallets: ${wallets.length}');

            return Scaffold(
              appBar: AppBar(
                title: Text('Wallet'),
                centerTitle: true,
              ),
              body: WalletScreen(),

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
                                    'displayedName before tap: $displayedName');

                                setState(() {
                                  Provider.of<Wallets>(context)
                                      .changeDisplayedName(wallets[idx].name);
                                  // displayedName = snapshot.data[idx].name;
                                });
                                print(
                                    'displayedName after tap: $displayedName');

                                Navigator.of(context).pop();
                              },
                              leading: Icon(Icons.lock_outline),
                              title: Text(wallets[idx]?.name ?? 'unknown name'),
                              // snapshot.data[idx]?.name ?? 'unknown name'),
                              trailing: Text(wallets[idx]?.id ?? 'unknown id'),
                              // snapshot.data[idx]?.id ?? 'unknown id'),
                            ),
                          );
                        },
                        itemCount: Provider.of<Wallets>(context).length,
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
