import '../models/nft_listing.dart';
import '../models/nft_offer.dart';
import '../core/yuku_types.dart';

/// Abstract interface for marketplace operations across different blockchains
abstract class MarketplaceProvider {
  /// Unique identifier for this provider
  String get id;

  /// Human-readable name of the provider
  String get name;

  /// Version of the provider
  String get version;

  /// Supported blockchain network
  BlockchainNetwork get network;

  /// Whether this provider is currently available
  bool get isAvailable;

  /// Initialize the provider
  Future<void> initialize();

  /// Dispose the provider
  Future<void> dispose();

  /// Get active listings
  Future<List<NFTListing>> getActiveListings({
    String? contractAddress,
    String? sellerAddress,
    int? limit,
    int? offset,
  });

  /// Get user listings
  Future<List<NFTListing>> getUserListings(String userAddress);

  /// Get specific listing
  Future<NFTListing?> getListing(String listingId);

  /// Create a new listing
  Future<String> createListing({
    required String nftId,
    required String contractAddress,
    required double price,
    required String currency,
    required String sellerAddress,
    int? expirationDays,
    Map<String, dynamic>? additionalParams,
  });

  /// Cancel a listing
  Future<bool> cancelListing(String listingId);

  /// Buy NFT from listing
  Future<String> buyNFT({
    required String listingId,
    required String buyerAddress,
    Map<String, dynamic>? additionalParams,
  });

  /// Get active offers
  Future<List<NFTOffer>> getActiveOffers({
    String? contractAddress,
    String? nftId,
    String? buyerAddress,
    int? limit,
    int? offset,
  });

  /// Get user offers
  Future<List<NFTOffer>> getUserOffers(String userAddress);

  /// Get offers for specific NFT
  Future<List<NFTOffer>> getNFTOffers(String nftId, String contractAddress);

  /// Get specific offer
  Future<NFTOffer?> getOffer(String offerId);

  /// Make an offer
  Future<String> makeOffer({
    required String nftId,
    required String contractAddress,
    required double amount,
    required String currency,
    required String buyerAddress,
    int? expirationDays,
    Map<String, dynamic>? additionalParams,
  });

  /// Accept an offer
  Future<bool> acceptOffer(String offerId);

  /// Reject an offer
  Future<bool> rejectOffer(String offerId);

  /// Cancel an offer
  Future<bool> cancelOffer(String offerId);

  /// Search listings
  Future<List<NFTListing>> searchListings({
    String? name,
    String? description,
    Map<String, dynamic>? attributes,
    double? minPrice,
    double? maxPrice,
    String? currency,
    String? contractAddress,
    int? limit,
    int? offset,
  });

  /// Get marketplace statistics
  Future<Map<String, dynamic>> getMarketplaceStats();

  /// Get collection statistics
  Future<Map<String, dynamic>> getCollectionStats(String contractAddress);

  /// Get user activity
  Future<Map<String, dynamic>> getUserActivity(String userAddress);

  /// Get supported currencies
  List<SupportedCurrency> getSupportedCurrencies();

  /// Check if currency is supported
  bool isCurrencySupported(String currency);

  /// Get marketplace fees
  Future<Map<String, double>> getMarketplaceFees();

  /// Calculate fees for a transaction
  Future<Map<String, double>> calculateFees({
    required double price,
    required String currency,
  });
}
