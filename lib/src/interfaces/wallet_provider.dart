import '../core/yuku_types.dart';

/// Abstract interface for wallet operations across different blockchains
abstract class WalletProvider {
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

  /// Whether wallet is connected
  bool get isConnected;

  /// Current connected address
  String? get currentAddress;

  /// Initialize the provider
  Future<void> initialize();

  /// Dispose the provider
  Future<void> dispose();

  /// Connect wallet
  Future<void> connect();

  /// Disconnect wallet
  Future<void> disconnect();

  /// Get wallet address
  Future<String> getAddress();

  /// Get wallet balance
  Future<double> getBalance(String address);

  /// Get balance for specific currency
  Future<double> getBalanceForCurrency(String address, String currency);

  /// Send transaction
  Future<String> sendTransaction({
    required String to,
    required double amount,
    required String currency,
    String? memo,
    Map<String, dynamic>? additionalParams,
  });

  /// Sign message
  Future<String> signMessage(String message);

  /// Sign transaction
  Future<String> signTransaction(Map<String, dynamic> transaction);

  /// Get transaction history
  Future<List<Map<String, dynamic>>> getTransactionHistory({
    String? address,
    int? limit,
    int? offset,
  });

  /// Get transaction details
  Future<Map<String, dynamic>> getTransactionDetails(String transactionHash);

  /// Estimate transaction fee
  Future<double> estimateTransactionFee({
    required String to,
    required double amount,
    required String currency,
  });

  /// Get supported currencies
  List<SupportedCurrency> getSupportedCurrencies();

  /// Check if address is valid for this network
  bool isValidAddress(String address);

  /// Get network information
  NetworkConfig getNetworkConfig();

  /// Switch network
  Future<void> switchNetwork(NetworkConfig networkConfig);

  /// Add token to wallet
  Future<bool> addToken({
    required String contractAddress,
    required String symbol,
    required String name,
    required int decimals,
    String? imageUrl,
  });

  /// Get token balance
  Future<double> getTokenBalance(String contractAddress, String address);

  /// Transfer token
  Future<String> transferToken({
    required String contractAddress,
    required String to,
    required double amount,
    Map<String, dynamic>? additionalParams,
  });

  /// Approve token spending
  Future<String> approveToken({
    required String contractAddress,
    required String spender,
    required double amount,
    Map<String, dynamic>? additionalParams,
  });

  /// Get token allowance
  Future<double> getTokenAllowance({
    required String contractAddress,
    required String owner,
    required String spender,
  });

  /// Get wallet information
  Future<Map<String, dynamic>> getWalletInfo();

  /// Export private key (if supported)
  Future<String> exportPrivateKey();

  /// Import private key
  Future<void> importPrivateKey(String privateKey);

  /// Generate new wallet
  Future<Map<String, dynamic>> generateWallet();

  /// Restore wallet from mnemonic
  Future<void> restoreWallet(String mnemonic);

  /// Get mnemonic phrase
  Future<String> getMnemonic();

  /// Verify mnemonic phrase
  bool verifyMnemonic(String mnemonic);
}
