import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../core/yuku_types.dart';

part 'transaction.g.dart';

/// Transaction model for blockchain operations
@JsonSerializable()
class Transaction extends Equatable {
  /// Transaction hash
  final String hash;

  /// From address
  final String from;

  /// To address
  final String to;

  /// Transaction amount
  final double amount;

  /// Currency
  final String currency;

  /// Transaction status
  final TransactionStatus status;

  /// When the transaction was created
  final DateTime createdAt;

  /// When the transaction was confirmed
  final DateTime? confirmedAt;

  /// Gas fee paid
  final double? gasFee;

  /// Gas price
  final double? gasPrice;

  /// Gas limit
  final int? gasLimit;

  /// Block number
  final int? blockNumber;

  /// Transaction index in block
  final int? transactionIndex;

  /// Additional transaction data
  final Map<String, dynamic> data;

  /// Network this transaction belongs to
  final BlockchainNetwork network;

  const Transaction({
    required this.hash,
    required this.from,
    required this.to,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.gasFee,
    this.gasPrice,
    this.gasLimit,
    this.blockNumber,
    this.transactionIndex,
    this.data = const {},
    required this.network,
  });

  /// Create Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  /// Convert Transaction to JSON
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  /// Create a copy with updated fields
  Transaction copyWith({
    String? hash,
    String? from,
    String? to,
    double? amount,
    String? currency,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    double? gasFee,
    double? gasPrice,
    int? gasLimit,
    int? blockNumber,
    int? transactionIndex,
    Map<String, dynamic>? data,
    BlockchainNetwork? network,
  }) {
    return Transaction(
      hash: hash ?? this.hash,
      from: from ?? this.from,
      to: to ?? this.to,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      gasFee: gasFee ?? this.gasFee,
      gasPrice: gasPrice ?? this.gasPrice,
      gasLimit: gasLimit ?? this.gasLimit,
      blockNumber: blockNumber ?? this.blockNumber,
      transactionIndex: transactionIndex ?? this.transactionIndex,
      data: data ?? this.data,
      network: network ?? this.network,
    );
  }

  /// Check if transaction is pending
  bool get isPending => status == TransactionStatus.pending;

  /// Check if transaction is confirmed
  bool get isConfirmed => status == TransactionStatus.confirmed;

  /// Check if transaction failed
  bool get isFailed => status == TransactionStatus.failed;

  /// Check if transaction is cancelled
  bool get isCancelled => status == TransactionStatus.cancelled;

  /// Get formatted amount
  String get formattedAmount => '${amount.toStringAsFixed(4)} $currency';

  /// Get formatted gas fee
  String get formattedGasFee {
    if (gasFee == null) return 'N/A';
    return '${gasFee!.toStringAsFixed(6)} $currency';
  }

  /// Get confirmation time
  Duration? get confirmationTime {
    if (confirmedAt == null) return null;
    return confirmedAt!.difference(createdAt);
  }

  /// Get transaction URL for blockchain explorer
  String get explorerUrl {
    switch (network) {
      case BlockchainNetwork.ethereum:
        return 'https://etherscan.io/tx/$hash';
      case BlockchainNetwork.polygon:
        return 'https://polygonscan.com/tx/$hash';
      case BlockchainNetwork.bsc:
        return 'https://bscscan.com/tx/$hash';
      case BlockchainNetwork.avalanche:
        return 'https://snowtrace.io/tx/$hash';
      case BlockchainNetwork.solana:
        return 'https://explorer.solana.com/tx/$hash';
      case BlockchainNetwork.icp:
        return 'https://dashboard.internetcomputer.org/transaction/$hash';
      case BlockchainNetwork.near:
        return 'https://explorer.near.org/transactions/$hash';
      case BlockchainNetwork.tron:
        return 'https://tronscan.org/#/transaction/$hash';
      case BlockchainNetwork.custom:
        return '';
    }
  }

  /// Get short hash for display
  String get shortHash {
    if (hash.length <= 10) return hash;
    return '${hash.substring(0, 6)}...${hash.substring(hash.length - 4)}';
  }

  /// Get short from address for display
  String get shortFrom {
    if (from.length <= 10) return from;
    return '${from.substring(0, 6)}...${from.substring(from.length - 4)}';
  }

  /// Get short to address for display
  String get shortTo {
    if (to.length <= 10) return to;
    return '${to.substring(0, 6)}...${to.substring(to.length - 4)}';
  }

  @override
  List<Object?> get props => [
    hash,
    from,
    to,
    amount,
    currency,
    status,
    createdAt,
    confirmedAt,
    gasFee,
    gasPrice,
    gasLimit,
    blockNumber,
    transactionIndex,
    data,
    network,
  ];
}
