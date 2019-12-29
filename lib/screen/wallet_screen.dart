import 'package:flutter/material.dart';
import 'package:wallet/screen/currency_screen.dart';
// import 'package:wallet/widgets/wallet_currency.dart';
import '../dummy_data.dart';

// To do
// fiatMoneyValue
// fiatMoneyValueSum

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  void selectCurrency(BuildContext context, num idx) {
    Navigator.of(context).pushNamed(CurrencyScreen.routeName, arguments: idx);
  }

  @override
  Widget build(BuildContext context) {
    final exchangeRate = EXCHANGERATES;
    final selectedWalletIdx = 'eth1';
    final selectedWallet =
        DUMMY_WALLETS.firstWhere((wallet) => wallet.id == selectedWalletIdx);
    final fiatMoneyValue = 0;

    String fiatValueSum(currenciesCoinNumber, exchangeRate) {
      double sum = 0;
      currenciesCoinNumber.forEach(
        (map) {
          sum += exchangeRate[map['currency']] * map['coinNumber'];
        },
      );
      return sum.toString();
    }

    String _calculateFiatValue(Map<String, Object> currentCoinNumber,
        Map<String, double> echangeRate) {
      var currency = currentCoinNumber['currency'];
      double result = exchangeRate[currency] * currentCoinNumber['coinNumber'];
      return result.toString();
    }

    return Column(
      children: <Widget>[
        // Wallet Sum up
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          height: 100,
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${selectedWallet.mainCurrency}-Wallet'),
                  Icon(Icons.more_horiz)
                ],
              ),
              Text(selectedWallet.mainAddress),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                      '\$ ${fiatValueSum(selectedWallet.currenciesCoinNumber, exchangeRate)}'),
                ],
              ),
            ],
          ),
        ),

        // Assets / Collectibles bar
        Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(10),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Assets '),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
            ],
          ),
        ),

        Container(
          height: 300,
          child: ListView.builder(
              itemBuilder: (ctx, idx) {
                return InkWell(
                  onTap: () => selectCurrency(context, idx),
                  child: ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text(
                        selectedWallet.currenciesCoinNumber[idx]['currency']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(selectedWallet.currenciesCoinNumber[idx]
                                ['coinNumber']
                            .toString()),
                        // Text(
                        //     '\$ ${double.parse(selectedWallet.currenciesCoinNumber[idx]['coinNumber'].toString())}'),
                        Text(
                            '\$ ${_calculateFiatValue(selectedWallet.currenciesCoinNumber[idx], exchangeRate)}'),
                      ],
                    ),
                  ),
                );
              },
              itemCount: selectedWallet.currenciesCoinNumber.length),
        )
      ],
    );
  }
}
