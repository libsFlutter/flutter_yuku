import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../core/yuku_types.dart';

part 'nft_listing.g.dart';

/// NFT listing model for marketplace operations
@JsonSerializable()
class NFTListing extends Equatable {
  /// Unique identifier of the listing
  final String id;

  /// NFT ID being listed
  final String nftId;

  /// Contract address or canister ID
  final String contractAddress;

  /// Blockchain network
  final BlockchainNetwork network;

  /// Listing price
  final double price;

  /// Currency of the price
  final String currency;

  /// Seller address
  final String sellerAddress;

  /// When the listing was created
  final DateTime createdAt;

  /// When the listing expires
  final DateTime? expiresAt;

  /// Current status of the listing
  final ListingStatus status;

  /// Buyer address (if sold)
  final String? buyerAddress;

  /// When the NFT was sold
  final DateTime? soldAt;

  /// Marketplace provider ID
  final String marketplaceProvider;

  const NFTListing({
    required this.id,
    required this.nftId,
    required this.contractAddress,
    required this.network,
    required this.price,
    required this.currency,
    required this.sellerAddress,
    required this.createdAt,
    this.expiresAt,
    required this.status,
    this.buyerAddress,
    this.soldAt,
    required this.marketplaceProvider,
  });

  /// Create NFTListing from JSON
  factory NFTListing.fromJson(Map<String, dynamic> json) =>
      _$NFTListingFromJson(json);

  /// Convert NFTListing to JSON
  Map<String, dynamic> toJson() => _$NFTListingToJson(this);

  /// Create a copy with updated fields
  NFTListing copyWith({
    String? id,
    String? nftId,
    String? contractAddress,
    BlockchainNetwork? network,
    double? price,
    String? currency,
    String? sellerAddress,
    DateTime? createdAt,
    DateTime? expiresAt,
    ListingStatus? status,
    String? buyerAddress,
    DateTime? soldAt,
    String? marketplaceProvider,
  }) {
    return NFTListing(
      id: id ?? this.id,
      nftId: nftId ?? this.nftId,
      contractAddress: contractAddress ?? this.contractAddress,
      network: network ?? this.network,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      sellerAddress: sellerAddress ?? this.sellerAddress,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      buyerAddress: buyerAddress ?? this.buyerAddress,
      soldAt: soldAt ?? this.soldAt,
      marketplaceProvider: marketplaceProvider ?? this.marketplaceProvider,
    );
  }

  /// Check if listing is active
  bool get isActive => status == ListingStatus.active;

  /// Check if listing is sold
  bool get isSold => status == ListingStatus.sold;

  /// Check if listing is expired
  bool get isExpired => status == ListingStatus.expired;

  /// Check if listing is cancelled
  bool get isCancelled => status == ListingStatus.cancelled;

  /// Get formatted price
  String get formattedPrice => '${price.toStringAsFixed(4)} $currency';

  /// Get time until expiration
  Duration? get timeUntilExpiration {
    if (expiresAt == null) return null;
    return expiresAt!.difference(DateTime.now());
  }

  /// Check if listing is expired by time
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
    price,
    currency,
    sellerAddress,
    createdAt,
    expiresAt,
    status,
    buyerAddress,
    soldAt,
    marketplaceProvider,
  ];
}
