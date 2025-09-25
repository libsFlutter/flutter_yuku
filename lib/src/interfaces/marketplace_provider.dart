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

  /// List NFT for sale
  Future<String> listNFT({
    required String tokenId,
    required String contractAddress,
    required double price,
    required String currency,
    int? duration,
    Map<String, dynamic>? additionalParams,
  });

  /// Buy NFT from listing
  Future<String> buyNFT(String listingId);

  /// Cancel NFT listing
  Future<String> cancelListing(String listingId);

  /// Update NFT listing price
  Future<String> updateListingPrice(String listingId, double newPrice);

  /// Get NFT listings
  Future<List<Map<String, dynamic>>> getListings({
    String? contractAddress,
    String? seller,
    String? buyer,
    double? minPrice,
    double? maxPrice,
    String? currency,
    int? limit,
    int? offset,
  });

  /// Get listing details
  Future<Map<String, dynamic>?> getListingDetails(String listingId);

  /// Get NFT offers
  Future<List<Map<String, dynamic>>> getOffers({
    String? tokenId,
    String? contractAddress,
    String? offerer,
    double? minPrice,
    double? maxPrice,
    String? currency,
    int? limit,
    int? offset,
  });

  /// Make offer for NFT
  Future<String> makeOffer({
    required String tokenId,
    required String contractAddress,
    required double price,
    required String currency,
    int? duration,
    Map<String, dynamic>? additionalParams,
  });

  /// Accept offer
  Future<String> acceptOffer(String offerId);

  /// Reject offer
  Future<String> rejectOffer(String offerId);

  /// Cancel offer
  Future<String> cancelOffer(String offerId);

  /// Get offer details
  Future<Map<String, dynamic>?> getOfferDetails(String offerId);

  /// Get marketplace statistics
  Future<Map<String, dynamic>> getMarketplaceStats({
    String? contractAddress,
    String? currency,
  });

  /// Get collection statistics
  Future<Map<String, dynamic>> getCollectionStats(String contractAddress);

  /// Get floor price for collection
  Future<double?> getFloorPrice(String contractAddress);

  /// Get average price for collection
  Future<double?> getAveragePrice(String contractAddress);

  /// Get total volume for collection
  Future<double> getTotalVolume(String contractAddress);

  /// Get recent sales
  Future<List<Map<String, dynamic>>> getRecentSales({
    String? contractAddress,
    int? limit,
    int? offset,
  });

  /// Search listings
  Future<List<Map<String, dynamic>>> searchListings({
    String? query,
    String? contractAddress,
    double? minPrice,
    double? maxPrice,
    String? currency,
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
  });

  /// Get supported currencies
  List<SupportedCurrency> getSupportedCurrencies();

  /// Get marketplace fees
  Future<Map<String, double>> getMarketplaceFees();

  /// Calculate marketplace fee for transaction
  Future<double> calculateMarketplaceFee(double price);

  /// Get royalty information
  Future<Map<String, dynamic>> getRoyaltyInfo({
    required String tokenId,
    required String contractAddress,
  });

  /// Set royalty information
  Future<String> setRoyaltyInfo({
    required String contractAddress,
    required double royaltyPercentage,
    required String royaltyRecipient,
  });

  /// Get marketplace events
  Stream<Map<String, dynamic>> getMarketplaceEvents({
    String? contractAddress,
    String? eventType,
  });

  /// Subscribe to marketplace events
  Future<void> subscribeToEvents({
    String? contractAddress,
    String? eventType,
    Function(Map<String, dynamic>)? onEvent,
  });

  /// Unsubscribe from marketplace events
  Future<void> unsubscribeFromEvents();

  /// Get marketplace configuration
  Future<Map<String, dynamic>> getMarketplaceConfig();

  /// Update marketplace configuration
  Future<void> updateMarketplaceConfig(Map<String, dynamic> config);

  /// Verify marketplace contract
  Future<bool> verifyMarketplaceContract(String contractAddress);

  /// Get marketplace health status
  Future<Map<String, dynamic>> getHealthStatus();
}
