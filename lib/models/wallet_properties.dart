import 'package:flutter/foundation.dart';

class WalletProperties {
  String walletName;
  String method;

  var mnemonic;
  List<String> mnemonicList;
  int mnemonicLength;
  var seed;
  var seedHex;
  var bip44Wallet;

  WalletProperties({
    @required walletName,
    @required method,
    
    @required mnemonic,
    @required mnemonicList,
    mnemonicLength = 12,
    @required seed,
    @required seedHex,
    @required bip44Wallet,
  });
}
