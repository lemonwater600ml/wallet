import 'package:flutter/material.dart';

class CreateWalletVarifyScreen extends StatelessWidget {
  static const routeName = '/create-wallet-verify';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initialize Wallet'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[],
              ),
            )),
      ),
    );
  }
}
