import 'package:flutter/foundation.dart';

class Transaction {
  final String chain;
  final String status;
  final int index;
  final String hash;
  final double value;
  final String from;
  final String to;
  final String date;
  final String datetime;
  final int timestamp;
  final String block_hash;
  final int block_number;
  final int gas;
  final double gas_price;      
  final int gas_used;
  final int nonce;
  final int confirmations;  
  final String token_transfers;
  final String input;
  final String walletId;
  final int coinIdx;

  Transaction({
      this.chain,
      this.status,
      this.index,
      this.hash,
      this.value,
      this.from,
      this.to,
      this.date,
      this.datetime,
      this.timestamp,
      this.block_hash,
      this.block_number,
      this.gas,
      this.gas_price,
      this.gas_used,
      this.nonce,
      this.confirmations,
      this.token_transfers,
      this.input,
      this.walletId,
      this.coinIdx});

      Map<String, dynamic> toMap() {
        return {
      'chain': chain,
      'status': status,
      'index': index,
      'hash': hash,
      'value': value,
      'from': from,
      'to': to,
      'date': date,
      'datetime': datetime,
      'timestamp': timestamp,
      'block_hash': block_hash,
      'block_number': block_number,
      'gas': gas,
      'gas_price': gas_price,
      'gas_used': gas_used,
      'this.nonce': nonce,
      'confirmations': confirmations,
      'token_transfers': token_transfers,
      'input': input,
      'walletId': walletId,
      'coinIdx': coinIdx,
        };
      }
}
