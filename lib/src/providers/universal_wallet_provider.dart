import 'package:flutter_yuku_universal/flutter_yuku_universal.dart';
import '../core/yuku_exceptions.dart';

/// Universal wallet provider that aggregates multiple wallet providers
class UniversalWalletProvider implements WalletProvider {
  final Map<String, WalletProvider> _providers = {};
  final Map<BlockchainNetwork, String> _defaultProviders = {};
  bool _isInitialized = false;

  @override
  String get id => 'universal-wallet-provider';

  @override
  String get name => 'Universal Wallet Provider';

  @override
  String get version => '1.0.0';

  @override
  BlockchainNetwork get network => BlockchainNetwork.custom;

  @override
  bool get isAvailable => _isInitialized;

  @override
  bool get isConnected {
    for (final provider in _providers.values) {
      if (provider.isConnected) {
        return true;
      }
    }
    return false;
  }

  @override
  String? get currentAddress {
    for (final provider in _providers.values) {
      if (provider.isConnected && provider.currentAddress != null) {
        return provider.currentAddress;
      }
    }
    return null;
  }

  /// Register a wallet provider
  void registerProvider(WalletProvider provider) {
    _providers[provider.id] = provider;
  }

  /// Set default provider for a network
  void setDefaultProvider(BlockchainNetwork network, String providerId) {
    _defaultProviders[network] = providerId;
  }

  /// Get provider for a specific network
  WalletProvider? _getProviderForNetwork(BlockchainNetwork network) {
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
        'Failed to initialize universal wallet provider: $e',
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
        'Failed to dispose universal wallet provider: $e',
      );
    }
  }

  @override
  Future<void> connect() async {
    _ensureInitialized();

    // Try to connect to the first available provider
    for (final provider in _providers.values) {
      try {
        await provider.connect();
        return;
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException('No wallet provider available for connection');
  }

  @override
  Future<void> disconnect() async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        await provider.disconnect();
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }
  }

  @override
  Future<String> getAddress() async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      if (provider.isConnected) {
        try {
          return await provider.getAddress();
        } catch (e) {
          // Continue with other providers
          continue;
        }
      }
    }

    throw ProviderException('No connected wallet provider available');
  }

  @override
  Future<double> getBalance(String address) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        return await provider.getBalance(address);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException('No wallet provider available for balance check');
  }

  @override
  Future<double> getBalanceForCurrency(String address, String currency) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        return await provider.getBalanceForCurrency(address, currency);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException(
      'No wallet provider available for currency balance check',
    );
  }

  @override
  Future<String> sendTransaction({
    required String to,
    required double amount,
    required String currency,
    String? memo,
    Map<String, dynamic>? additionalParams,
  }) async {
    _ensureInitialized();

    // Determine network from additional params
    final network =
        additionalParams?['network'] as BlockchainNetwork? ??
        BlockchainNetwork.ethereum;

    final provider = _getProviderForNetwork(network);
    if (provider == null) {
      throw ProviderException(
        'No wallet provider available for network: $network',
      );
    }

    return await provider.sendTransaction(
      to: to,
      amount: amount,
      currency: currency,
      memo: memo,
      additionalParams: additionalParams,
    );
  }

  @override
  Future<String> signMessage(String message) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      if (provider.isConnected) {
        try {
          return await provider.signMessage(message);
        } catch (e) {
          // Continue with other providers
          continue;
        }
      }
    }

    throw ProviderException(
      'No connected wallet provider available for signing',
    );
  }

  @override
  Future<String> signTransaction(Map<String, dynamic> transaction) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      if (provider.isConnected) {
        try {
          return await provider.signTransaction(transaction);
        } catch (e) {
          // Continue with other providers
          continue;
        }
      }
    }

    throw ProviderException(
      'No connected wallet provider available for transaction signing',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getTransactionHistory({
    String? address,
    int? limit,
    int? offset,
  }) async {
    _ensureInitialized();

    final allTransactions = <Map<String, dynamic>>[];
    for (final provider in _providers.values) {
      try {
        final transactions = await provider.getTransactionHistory(
          address: address,
          limit: limit,
          offset: offset,
        );
        allTransactions.addAll(transactions);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allTransactions;
  }

  @override
  Future<Map<String, dynamic>> getTransactionDetails(
    String transactionHash,
  ) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final details = await provider.getTransactionDetails(transactionHash);
        if (details.isNotEmpty) {
          return details;
        }
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException('Transaction not found in any provider');
  }

  @override
  Future<double> estimateTransactionFee({
    required String to,
    required double amount,
    required String currency,
  }) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        return await provider.estimateTransactionFee(
          to: to,
          amount: amount,
          currency: currency,
        );
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException('No wallet provider available for fee estimation');
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
  bool isValidAddress(String address) {
    for (final provider in _providers.values) {
      if (provider.isValidAddress(address)) {
        return true;
      }
    }
    return false;
  }

  @override
  NetworkConfig getNetworkConfig() {
    // Return a default network config
    return const NetworkConfig(
      name: 'Universal Network',
      rpcUrl: '',
      chainId: '0',
      network: BlockchainNetwork.custom,
      isTestnet: false,
    );
  }

  @override
  Future<void> switchNetwork(NetworkConfig networkConfig) async {
    _ensureInitialized();

    final provider = _getProviderForNetwork(networkConfig.network);
    if (provider == null) {
      throw ProviderException(
        'No wallet provider available for network: ${networkConfig.network}',
      );
    }

    await provider.switchNetwork(networkConfig);
  }

  @override
  Future<bool> addToken({
    required String contractAddress,
    required String symbol,
    required String name,
    required int decimals,
    String? imageUrl,
  }) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        final result = await provider.addToken(
          contractAddress: contractAddress,
          symbol: symbol,
          name: name,
          decimals: decimals,
          imageUrl: imageUrl,
        );
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
  Future<double> getTokenBalance(String contractAddress, String address) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        return await provider.getTokenBalance(contractAddress, address);
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException(
      'No wallet provider available for token balance check',
    );
  }

  @override
  Future<String> transferToken({
    required String contractAddress,
    required String to,
    required double amount,
    Map<String, dynamic>? additionalParams,
  }) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        return await provider.transferToken(
          contractAddress: contractAddress,
          to: to,
          amount: amount,
          additionalParams: additionalParams,
        );
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException('No wallet provider available for token transfer');
  }

  @override
  Future<String> approveToken({
    required String contractAddress,
    required String spender,
    required double amount,
    Map<String, dynamic>? additionalParams,
  }) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        return await provider.approveToken(
          contractAddress: contractAddress,
          spender: spender,
          amount: amount,
          additionalParams: additionalParams,
        );
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException('No wallet provider available for token approval');
  }

  @override
  Future<double> getTokenAllowance({
    required String contractAddress,
    required String owner,
    required String spender,
  }) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        return await provider.getTokenAllowance(
          contractAddress: contractAddress,
          owner: owner,
          spender: spender,
        );
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException(
      'No wallet provider available for token allowance check',
    );
  }

  @override
  Future<Map<String, dynamic>> getWalletInfo() async {
    _ensureInitialized();

    final allInfo = <String, dynamic>{};
    for (final provider in _providers.values) {
      try {
        final info = await provider.getWalletInfo();
        allInfo[provider.id] = info;
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    return allInfo;
  }

  @override
  Future<String> exportPrivateKey() async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      if (provider.isConnected) {
        try {
          return await provider.exportPrivateKey();
        } catch (e) {
          // Continue with other providers
          continue;
        }
      }
    }

    throw ProviderException(
      'No connected wallet provider available for private key export',
    );
  }

  @override
  Future<void> importPrivateKey(String privateKey) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        await provider.importPrivateKey(privateKey);
        return;
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException(
      'No wallet provider available for private key import',
    );
  }

  @override
  Future<Map<String, dynamic>> generateWallet() async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        return await provider.generateWallet();
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException(
      'No wallet provider available for wallet generation',
    );
  }

  @override
  Future<void> restoreWallet(String mnemonic) async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      try {
        await provider.restoreWallet(mnemonic);
        return;
      } catch (e) {
        // Continue with other providers
        continue;
      }
    }

    throw ProviderException(
      'No wallet provider available for wallet restoration',
    );
  }

  @override
  Future<String> getMnemonic() async {
    _ensureInitialized();

    for (final provider in _providers.values) {
      if (provider.isConnected) {
        try {
          return await provider.getMnemonic();
        } catch (e) {
          // Continue with other providers
          continue;
        }
      }
    }

    throw ProviderException(
      'No connected wallet provider available for mnemonic retrieval',
    );
  }

  @override
  bool verifyMnemonic(String mnemonic) {
    for (final provider in _providers.values) {
      if (provider.verifyMnemonic(mnemonic)) {
        return true;
      }
    }
    return false;
  }

  /// Ensure provider is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw ServiceNotInitializedException(
        'Universal wallet provider is not initialized',
      );
    }
  }
}
