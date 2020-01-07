import 'package:flutter/material.dart';

class CreateWalletCheckScreen extends StatelessWidget {
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
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'question1'),
                    validator: (value) {
                      if (false) { // check question
                        return 'The answer is incorrect.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'question2'),
                    validator: (value) {
                      if (false) { // check question
                        return 'Please type in correct answer.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'question3'),
                    validator: (value) {
                      if (false) { // check question
                        return 'The answer is incorrect';
                      }
                      return null;
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }
}
