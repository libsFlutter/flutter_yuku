import 'package:flutter_yuku_universal/flutter_yuku_universal.dart';
import '../core/yuku_exceptions.dart';

/// Universal marketplace provider that aggregates multiple marketplace providers
class UniversalMarketplaceProvider implements MarketplaceProvider {
  final Map<String, MarketplaceProvider> _providers = {};
  final Map<BlockchainNetwork, String> _defaultProviders = {};
  bool _isInitialized = false;

  @override
  String get id => 'universal-marketplace-provider';

  @override
  String get name => 'Universal Marketplace Provider';

  @override
  String get version => '1.0.0';

  @override
  BlockchainNetwork get network => BlockchainNetwork.custom;

  @override
  bool get isAvailable => _isInitialized;

  /// Register a marketplace provider
  void registerProvider(MarketplaceProvider provider) {
    _providers[provider.id] = provider;
  }

  /// Set default provider for a network
  void setDefaultProvider(BlockchainNetwork network, String providerId) {
    _defaultProviders[network] = providerId;
  }

  /// Get provider for a specific network
  MarketplaceProvider? _getProviderForNetwork(BlockchainNetwork network) {
    final providerId = _defaultProviders[network];
    if (providerId != null) {
      return _providers[providerId];
    }

    // Find provider by network
    for (final provider in _providers.values) {
      if (provider.network == network) {
        return provider;
      }
    }

    return null;
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      for (final provider in _providers.values) {
        await provider.initialize();
      }
      _isInitialized = true;
    } catch (e) {
      throw ServiceNotInitializedException(
        'Failed to initialize universal marketplace provider: $e',
      );
    }
  }

  @override
  Future<void> dispose() async {
    if (!_isInitialized) return;

    try {
      for (final provider in _providers.values) {
        await provider.dispose();
      }
      _providers.clear();
      _defaultProviders.clear();
      _isInitialized = false;
    } catch (e) {
      throw ProviderException(
        'Failed to dispose universal marketplace provider: $e',
      );
    }
  }

  @override
  Future<List<NFTListing>> getActiveListings({
    String? contractAddress,
    String? sellerAddress,
    int? limit,
    int? offset,
  }) async {
    _ensureInitialized();

    final allListings = <NFTListing>[];
    for (final provider in _providers.values) {
      try {
        final listings = await provider.getActiveListings(
          contractAddress: contractAddress,
          sellerAddress: sellerAddress,
          limit: limit,
          offset: offset,
        );
        allListings.addAll(listings);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allListings;
  }

  @override
  Future<List<NFTListing>> getUserListings(String userAddress) async {
    _ensureInitialized();

    final allListings = <NFTListing>[];
    for (final provider in _providers.values) {
      try {
        final listings = await provider.getUserListings(userAddress);
        allListings.addAll(listings);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allListings;
  }

  @override
  Future<NFTListing?> getListing(String listingId) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final listing = await provider.getListing(listingId);
        if (listing != null) {
          return listing;
        }
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return null;
  }

  @override
  Future<String> createListing({
    required String nftId,
    required String contractAddress,
    required double price,
    required String currency,
    required String sellerAddress,
    int? expirationDays,
    Map<String, dynamic>? additionalParams,
  }) async {
    _ensureInitialized();

    // Determine network from contract address or additional params
    final network =
        additionalParams?['network'] as BlockchainNetwork? ??
        BlockchainNetwork.ethereum;

    final provider = _getProviderForNetwork(network);
    if (provider == null) {
      throw ProviderException(
        'No marketplace provider available for network: $network',
      );
    }

    return await provider.createListing(
      nftId: nftId,
      contractAddress: contractAddress,
      price: price,
      currency: currency,
      sellerAddress: sellerAddress,
      expirationDays: expirationDays,
      additionalParams: additionalParams,
    );
  }

  @override
  Future<bool> cancelListing(String listingId) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final result = await provider.cancelListing(listingId);
        if (result) {
          return true;
        }
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return false;
  }

  @override
  Future<String> buyNFT({
    required String listingId,
    required String buyerAddress,
    Map<String, dynamic>? additionalParams,
  }) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final result = await provider.buyNFT(
          listingId: listingId,
          buyerAddress: buyerAddress,
          additionalParams: additionalParams,
        );
        return result;
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException('Failed to buy NFT from any provider');
  }

  @override
  Future<List<NFTOffer>> getActiveOffers({
    String? contractAddress,
    String? nftId,
    String? buyerAddress,
    int? limit,
    int? offset,
  }) async {
    _ensureInitialized();

    final allOffers = <NFTOffer>[];
    for (final provider in _providers.values) {
      try {
        final offers = await provider.getActiveOffers(
          contractAddress: contractAddress,
          nftId: nftId,
          buyerAddress: buyerAddress,
          limit: limit,
          offset: offset,
        );
        allOffers.addAll(offers);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allOffers;
  }

  @override
  Future<List<NFTOffer>> getUserOffers(String userAddress) async {
    _ensureInitialized();

    final allOffers = <NFTOffer>[];
    for (final provider in _providers.values) {
      try {
        final offers = await provider.getUserOffers(userAddress);
        allOffers.addAll(offers);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allOffers;
  }

  @override
  Future<List<NFTOffer>> getNFTOffers(
    String nftId,
    String contractAddress,
  ) async {
    _ensureInitialized();

    final allOffers = <NFTOffer>[];
    for (final provider in _providers.values) {
      try {
        final offers = await provider.getNFTOffers(nftId, contractAddress);
        allOffers.addAll(offers);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allOffers;
  }

  @override
  Future<NFTOffer?> getOffer(String offerId) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final offer = await provider.getOffer(offerId);
        if (offer != null) {
          return offer;
        }
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return null;
  }

  @override
  Future<String> makeOffer({
    required String nftId,
    required String contractAddress,
    required double amount,
    required String currency,
    required String buyerAddress,
    int? expirationDays,
    Map<String, dynamic>? additionalParams,
  }) async {
    _ensureInitialized();

    // Determine network from contract address or additional params
    final network =
        additionalParams?['network'] as BlockchainNetwork? ??
        BlockchainNetwork.ethereum;

    final provider = _getProviderForNetwork(network);
    if (provider == null) {
      throw ProviderException(
        'No marketplace provider available for network: $network',
      );
    }

    return await provider.makeOffer(
      nftId: nftId,
      contractAddress: contractAddress,
      amount: amount,
      currency: currency,
      buyerAddress: buyerAddress,
      expirationDays: expirationDays,
      additionalParams: additionalParams,
    );
  }

  @override
  Future<bool> acceptOffer(String offerId) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final result = await provider.acceptOffer(offerId);
        if (result) {
          return true;
        }
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return false;
  }

  @override
  Future<bool> rejectOffer(String offerId) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final result = await provider.rejectOffer(offerId);
        if (result) {
          return true;
        }
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return false;
  }

  @override
  Future<bool> cancelOffer(String offerId) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final result = await provider.cancelOffer(offerId);
        if (result) {
          return true;
        }
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return false;
  }

  @override
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
  }) async {
    _ensureInitialized();

    final allListings = <NFTListing>[];
    for (final provider in _providers.values) {
      try {
        final listings = await provider.searchListings(
          name: name,
          description: description,
          attributes: attributes,
          minPrice: minPrice,
          maxPrice: maxPrice,
          currency: currency,
          contractAddress: contractAddress,
          limit: limit,
          offset: offset,
        );
        allListings.addAll(listings);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allListings;
  }

  @override
  Future<Map<String, dynamic>> getMarketplaceStats() async {
    _ensureInitialized();

    final allStats = <String, dynamic>{};
    for (final provider in _providers.values) {
      try {
        final stats = await provider.getMarketplaceStats();
        allStats[provider.id] = stats;
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allStats;
  }

  @override
  Future<Map<String, dynamic>> getCollectionStats(
    String contractAddress,
  ) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final stats = await provider.getCollectionStats(contractAddress);
        if (stats.isNotEmpty) {
          return stats;
        }
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return {};
  }

  @override
  Future<Map<String, dynamic>> getUserActivity(String userAddress) async {
    _ensureInitialized();

    final allActivity = <String, dynamic>{};
    for (final provider in _providers.values) {
      try {
        final activity = await provider.getUserActivity(userAddress);
        allActivity[provider.id] = activity;
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allActivity;
  }

  @override
  List<SupportedCurrency> getSupportedCurrencies() {
    final currencies = <SupportedCurrency>[];
    for (final provider in _providers.values) {
      currencies.addAll(provider.getSupportedCurrencies());
    }
    return currencies;
  }

  @override
  bool isCurrencySupported(String currency) {
    for (final provider in _providers.values) {
      if (provider.isCurrencySupported(currency)) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<Map<String, double>> getMarketplaceFees() async {
    _ensureInitialized();

    final allFees = <String, double>{};
    for (final provider in _providers.values) {
      try {
        final fees = await provider.getMarketplaceFees();
        allFees.addAll(fees);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allFees;
  }

  @override
  Future<Map<String, double>> calculateFees({
    required double price,
    required String currency,
  }) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final fees = await provider.calculateFees(
          price: price,
          currency: currency,
        );
        if (fees.isNotEmpty) {
          return fees;
        }
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return {};
  }

  /// Ensure provider is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw ServiceNotInitializedException(
        'Universal marketplace provider is not initialized',
      );
    }
  }
}
