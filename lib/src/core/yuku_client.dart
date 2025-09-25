import '../interfaces/nft_provider.dart';
import '../interfaces/wallet_provider.dart';
import '../interfaces/marketplace_provider.dart';
import '../core/yuku_types.dart';
import '../core/yuku_exceptions.dart';

/// Main client for Yuku operations across multiple blockchains
class YukuClient {
  final Map<String, NFTProvider> _nftProviders = {};
  final Map<String, WalletProvider> _walletProviders = {};
  final Map<String, MarketplaceProvider> _marketplaceProviders = {};
  final Map<BlockchainNetwork, String> _defaultProviders = {};
  final Map<BlockchainNetwork, NetworkConfig> _networkConfigs = {};
  bool _isInitialized = false;

  /// Whether the client is initialized
  bool get isInitialized => _isInitialized;

  /// Get supported networks
  Set<BlockchainNetwork> getSupportedNetworks() {
    return _networkConfigs.keys.toSet();
  }

  /// Check if a network is supported
  bool isNetworkSupported(BlockchainNetwork network) {
    return _networkConfigs.containsKey(network);
  }

  /// Initialize the client
  Future<void> initialize() async {
    if (_isInitialized) {
      throw ServiceAlreadyInitializedException(
        'Yuku client is already initialized',
      );
    }

    try {
      // Initialize all registered providers
      for (final provider in _nftProviders.values) {
        await provider.initialize();
      }

      for (final provider in _walletProviders.values) {
        await provider.initialize();
      }

      for (final provider in _marketplaceProviders.values) {
        await provider.initialize();
      }

      _isInitialized = true;
    } catch (e) {
      throw ServiceNotInitializedException(
        'Failed to initialize Yuku client: $e',
      );
    }
  }

  /// Dispose the client
  Future<void> dispose() async {
    if (!_isInitialized) return;

    try {
      // Dispose all providers
      for (final provider in _nftProviders.values) {
        await provider.dispose();
      }

      for (final provider in _walletProviders.values) {
        await provider.dispose();
      }

      for (final provider in _marketplaceProviders.values) {
        await provider.dispose();
      }

      _nftProviders.clear();
      _walletProviders.clear();
      _marketplaceProviders.clear();
      _defaultProviders.clear();
      _networkConfigs.clear();
      _isInitialized = false;
    } catch (e) {
      throw ProviderException('Failed to dispose Yuku client: $e');
    }
  }

  /// Set network configuration
  void setNetworkConfig(BlockchainNetwork network, NetworkConfig config) {
    _networkConfigs[network] = config;
  }

  /// Get network configuration
  NetworkConfig? getNetworkConfig(BlockchainNetwork network) {
    return _networkConfigs[network];
  }

  /// Set default provider for a network
  void setDefaultProvider(BlockchainNetwork network, String providerId) {
    _defaultProviders[network] = providerId;
  }

  /// Get default provider for a network
  String? getDefaultProvider(BlockchainNetwork network) {
    return _defaultProviders[network];
  }

  /// Register NFT provider
  void registerNFTProvider(NFTProvider provider) {
    _nftProviders[provider.id] = provider;
  }

  /// Register wallet provider
  void registerWalletProvider(WalletProvider provider) {
    _walletProviders[provider.id] = provider;
  }

  /// Register marketplace provider
  void registerMarketplaceProvider(MarketplaceProvider provider) {
    _marketplaceProviders[provider.id] = provider;
  }

  /// Unregister NFT provider
  void unregisterNFTProvider(String providerId) {
    _nftProviders.remove(providerId);
  }

  /// Unregister wallet provider
  void unregisterWalletProvider(String providerId) {
    _walletProviders.remove(providerId);
  }

  /// Unregister marketplace provider
  void unregisterMarketplaceProvider(String providerId) {
    _marketplaceProviders.remove(providerId);
  }

  /// Get NFT provider for a specific network
  NFTProvider? getNFTProvider(BlockchainNetwork network) {
    _ensureInitialized();

    final providerId = _defaultProviders[network];
    if (providerId != null) {
      final provider = _nftProviders[providerId];
      if (provider != null) return provider;
    }

    // Find provider by network
    for (final provider in _nftProviders.values) {
      if (provider.network == network) {
        return provider;
      }
    }

    return null;
  }

  /// Get wallet provider for a specific network
  WalletProvider? getWalletProvider(BlockchainNetwork network) {
    _ensureInitialized();

    final providerId = _defaultProviders[network];
    if (providerId != null) {
      final provider = _walletProviders[providerId];
      if (provider != null) return provider;
    }

    // Find provider by network
    for (final provider in _walletProviders.values) {
      if (provider.network == network) {
        return provider;
      }
    }

    return null;
  }

  /// Get marketplace provider for a specific network
  MarketplaceProvider? getMarketplaceProvider(BlockchainNetwork network) {
    _ensureInitialized();

    final providerId = _defaultProviders[network];
    if (providerId != null) {
      final provider = _marketplaceProviders[providerId];
      if (provider != null) return provider;
    }

    // Find provider by network
    for (final provider in _marketplaceProviders.values) {
      if (provider.network == network) {
        return provider;
      }
    }

    return null;
  }

  /// Get all available NFT providers
  List<NFTProvider> getAvailableNFTProviders() {
    return _nftProviders.values.toList();
  }

  /// Get all available wallet providers
  List<WalletProvider> getAvailableWalletProviders() {
    return _walletProviders.values.toList();
  }

  /// Get all available marketplace providers
  List<MarketplaceProvider> getAvailableMarketplaceProviders() {
    return _marketplaceProviders.values.toList();
  }

  /// Get provider statistics
  Map<String, dynamic> getProviderStats() {
    return {
      'nftProviders': _nftProviders.length,
      'walletProviders': _walletProviders.length,
      'marketplaceProviders': _marketplaceProviders.length,
      'supportedNetworks': _networkConfigs.keys.length,
      'isInitialized': _isInitialized,
    };
  }

  /// Get client information
  Map<String, dynamic> getClientInfo() {
    return {
      'version': '1.0.0',
      'isInitialized': _isInitialized,
      'supportedNetworks': _networkConfigs.keys.map((e) => e.name).toList(),
      'providers': getProviderStats(),
    };
  }

  /// Ensure client is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw ServiceNotInitializedException('Yuku client is not initialized');
    }
  }
}
