import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../core/yuku_types.dart';

part 'nft_offer.g.dart';

/// NFT offer model for marketplace operations
@JsonSerializable()
class NFTOffer extends Equatable {
  /// Unique identifier of the offer
  final String id;

  /// NFT ID being offered for
  final String nftId;

  /// Contract address or canister ID
  final String contractAddress;

  /// Blockchain network
  final BlockchainNetwork network;

  /// Offer amount
  final double amount;

  /// Currency of the offer
  final String currency;

  /// Buyer address making the offer
  final String buyerAddress;

  /// When the offer was created
  final DateTime createdAt;

  /// When the offer expires
  final DateTime? expiresAt;

  /// Current status of the offer
  final OfferStatus status;

  /// Marketplace provider ID
  final String marketplaceProvider;

  const NFTOffer({
    required this.id,
    required this.nftId,
    required this.contractAddress,
    required this.network,
    required this.amount,
    required this.currency,
    required this.buyerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    required this.marketplaceProvider,
  });

  /// Create NFTOffer from JSON
  factory NFTOffer.fromJson(Map<String, dynamic> json) => _$NFTOfferFromJson(json);

  /// Convert NFTOffer to JSON
  Map<String, dynamic> toJson() => _$NFTOfferToJson(this);

  /// Create a copy with updated fields
  NFTOffer copyWith({
    String? id,
    String? nftId,
    String? contractAddress,
    BlockchainNetwork? network,
    double? amount,
    String? currency,
    String? buyerAddress,
    DateTime? createdAt,
    DateTime? expiresAt,
    OfferStatus? status,
    String? marketplaceProvider,
  }) {
    return NFTOffer(
      id: id ?? this.id,
      nftId: nftId ?? this.nftId,
      contractAddress: contractAddress ?? this.contractAddress,
      network: network ?? this.network,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      buyerAddress: buyerAddress ?? this.buyerAddress,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      marketplaceProvider: marketplaceProvider ?? this.marketplaceProvider,
    );
  }

  /// Check if offer is pending
  bool get isPending => status == OfferStatus.pending;

  /// Check if offer is accepted
  bool get isAccepted => status == OfferStatus.accepted;

  /// Check if offer is rejected
  bool get isRejected => status == OfferStatus.rejected;

  /// Check if offer is expired
  bool get isExpired => status == OfferStatus.expired;

  /// Check if offer is cancelled
  bool get isCancelled => status == OfferStatus.cancelled;

  /// Get formatted amount
  String get formattedAmount => '${amount.toStringAsFixed(4)} $currency';

  /// Get time until expiration
  Duration? get timeUntilExpiration {
    if (expiresAt == null) return null;
    return expiresAt!.difference(DateTime.now());
  }

  /// Check if offer is expired by time
  bool get isExpiredByTime {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  @override
  List<Object?> get props => [
    id,
    nftId,
    contractAddress,
    network,
    amount,
    currency,
    buyerAddress,
    createdAt,
    expiresAt,
    status,
    marketplaceProvider,
  ];
}
