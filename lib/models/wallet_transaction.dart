class WalletTransaction {
  final String chain;
  final String status;
  final int idx;
  final String hash;
  final double value;
  final String fromAddr;
  final String toAddr;
  final String date;
  final String datetime;
  final int timestamp;
  final String blockHash;
  final int blockNumber;
  final int gas;
  final double gasPrice;      
  final int gasUsed;
  final int nonce;
  final int confirmations;  
  final String tokenTransfers;
  final String input;
  final String walletId;
  final int coinIdx;

  WalletTransaction({
      this.chain,
      this.status,
      this.idx,
      this.hash,
      this.value,
      this.fromAddr,
      this.toAddr,
      this.date,
      this.datetime,
      this.timestamp,
      this.blockHash,
      this.blockNumber,
      this.gas,
      this.gasPrice,
      this.gasUsed,
      this.nonce,
      this.confirmations,
      this.tokenTransfers,
      this.input,
      this.walletId,
      this.coinIdx});

      Map<String, dynamic> toMap() {
        return { 
      'chain': chain,
      'status': status,
      'idx': idx,
      'hash': hash,
      'value': value,
      'fromAddr': fromAddr,
      'toAddr': toAddr,
      'date': date,
      'datetime': datetime,
      'timestamp': timestamp,
      'blockHash': blockHash,
      'blockNumber': blockNumber,
      'gas': gas,
      'gasPrice': gasPrice,
      'gasUsed': gasUsed,
      'nonce': nonce,
      'confirmations': confirmations,
      'tokenTransfers': tokenTransfers,
      'input': input,
      'walletId': walletId,
      'coinIdx': coinIdx,
        };
      }
}
