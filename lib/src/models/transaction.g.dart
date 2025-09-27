// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  hash: json['hash'] as String,
  from: json['from'] as String,
  to: json['to'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  confirmedAt: json['confirmedAt'] == null
      ? null
      : DateTime.parse(json['confirmedAt'] as String),
  gasFee: (json['gasFee'] as num?)?.toDouble(),
  gasPrice: (json['gasPrice'] as num?)?.toDouble(),
  gasLimit: (json['gasLimit'] as num?)?.toInt(),
  blockNumber: (json['blockNumber'] as num?)?.toInt(),
  transactionIndex: (json['transactionIndex'] as num?)?.toInt(),
  data: json['data'] as Map<String, dynamic>? ?? const {},
  network: $enumDecode(_$BlockchainNetworkEnumMap, json['network']),
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'from': instance.from,
      'to': instance.to,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'gasFee': instance.gasFee,
      'gasPrice': instance.gasPrice,
      'gasLimit': instance.gasLimit,
      'blockNumber': instance.blockNumber,
      'transactionIndex': instance.transactionIndex,
      'data': instance.data,
      'network': _$BlockchainNetworkEnumMap[instance.network]!,
    };

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.confirmed: 'confirmed',
  TransactionStatus.failed: 'failed',
  TransactionStatus.cancelled: 'cancelled',
};

const _$BlockchainNetworkEnumMap = {
  BlockchainNetwork.ethereum: 'ethereum',
  BlockchainNetwork.solana: 'solana',
  BlockchainNetwork.polygon: 'polygon',
  BlockchainNetwork.bsc: 'bsc',
  BlockchainNetwork.avalanche: 'avalanche',
  BlockchainNetwork.icp: 'icp',
  BlockchainNetwork.near: 'near',
  BlockchainNetwork.tron: 'tron',
  BlockchainNetwork.custom: 'custom',
};
