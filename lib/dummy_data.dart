import './models/wallet_old.dart';

const DUMMY_WALLETS = const [
  WalletOld(
    id: 'ETH1',
    type: 'ETH',
    address: '0xTe34Gder1234567890',
    coinsNumber: [
      {
        'currency': 'ETH',
        'coinNumber': 16.7,
      },
      {
        'currency': 'USDT',
        'coinNumber': 5.0,
      }
    ],
  ), 
  // Wallet(
  //   id: 'btc1',
  //   mainCurrency: 'BTC',
  //   mainAddress: 'superRich1234567890',
  //   currenciesCoinNumber: [
  //     {
  //       'currency': 'BTC',
  //       'coinNumber': 1.00,
  //     },
  //   ],
  // )
];

const EXCHANGERATES = {
  'ETH': 124.21,
  'USDT': 1.011,
};

final TRANSACTIONS_RCV = [
  {
    'id': "000001",
    'type': 'ETH',
    'tranType': 'Received',
    'amount': '3',
    'from': '0xTe34Gder1234567890',
    'to': '000ethreceive000',
    'time': DateTime.parse("2019-07-20 20:18:04"),
    'minerFee': 0.00004,
    'status': 'Completed!',
    'confirmedNum': 645,
  },
  {
    'id': "000002",
    'type': 'ETH',
    'tranType': 'Received',
    'amount': "5",
    'from': '0xTe34Gder1234567890',
    'to': '000ethreceive000',
    'time': DateTime.parse("2019-07-20 22:18:04"),
    'minerFee': 0.00004,
    'status': 'Completed!',
    'confirmedNum': 25,
  },
  {
    'id': "000003",
    'type': 'ETH',
    'tranType': 'Received',
    'amount': "7",
    'from': '0xTe34Gder1234567890',
    'to': '000ethreceive003',
    'time': DateTime.parse("2019-07-20 22:38:04"),
    'minerFee': 0.00004,
    'status': 'Completed!',
    'confirmedNum': 25,
  },
  {
    'id': "000004",
    'type': 'ETH',
    'tranType': 'Received',
    'amount': "2",
    'from': '0xTe34Gder1234567890',
    'to': '000ethreceive004',
    'time': DateTime.parse("2019-07-20 22:53:04"),
    'minerFee': 0.00004,
    'status': 'Completed!',
    'confirmedNum': 25,
  },
];

final TRANSACTIONS_SND = [
  {
    'id': "000001",
    'type': 'ETH',
    'tranType': 'Send',
    'amount': '0.1',
    'from': '000ethreceive000',
    'to': '0xTe34Gder1234567890',
    'time': DateTime.parse("2019-07-20 20:18:04Z"),
    'minerFee': 0.00004,
    'status': 'Completed!',
    'confirmedNum': 645,
  },
  {
    'id': "000002",
    'type': 'ETH',
    'tranType': 'Send',
    'amount': "0.2",
    'from': '000ethreceive000',
    'to': '0xTe34Gder1234567890',
    'time': DateTime.parse("2019-07-20 22:18:04Z"),
    'minerFee': 0.00004,
    'status': 'Completed!',
    'confirmedNum': 25,
  },
];
