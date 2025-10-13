/// Base exception for all Yuku operations
abstract class YukuException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const YukuException(this.message, {this.code, this.details});

  @override
  String toString() => 'YukuException: $message';
}

/// Exception for NFT operations
class NFTOperationException extends YukuException {
  const NFTOperationException(super.message, {super.code, super.details});
}

/// Exception for wallet operations
class WalletOperationException extends YukuException {
  const WalletOperationException(super.message, {super.code, super.details});
}

/// Exception for marketplace operations
class MarketplaceOperationException extends YukuException {
  const MarketplaceOperationException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Exception for marketplace operations (alias)
class MarketplaceException extends MarketplaceOperationException {
  const MarketplaceException(super.message, {super.code, super.details});
}

/// Exception for network operations
class NetworkException extends YukuException {
  const NetworkException(super.message, {super.code, super.details});
}

/// Exception for configuration issues
class ConfigurationException extends YukuException {
  const ConfigurationException(super.message, {super.code, super.details});
}

/// Exception for provider operations
class ProviderException extends YukuException {
  const ProviderException(super.message, {super.code, super.details});
}

/// Exception for transaction operations
class TransactionException extends YukuException {
  const TransactionException(super.message, {super.code, super.details});
}

/// Exception for validation errors
class ValidationException extends YukuException {
  const ValidationException(super.message, {super.code, super.details});
}

/// Exception for service initialization
class ServiceNotInitializedException extends YukuException {
  const ServiceNotInitializedException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Exception for service already initialized
class ServiceAlreadyInitializedException extends YukuException {
  const ServiceAlreadyInitializedException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Exception for timeout operations
class TimeoutException extends YukuException {
  const TimeoutException(super.message, {super.code, super.details});
}

/// Exception for authentication errors
class AuthenticationException extends YukuException {
  const AuthenticationException(super.message, {super.code, super.details});
}

/// Exception for authorization errors
class AuthorizationException extends YukuException {
  const AuthorizationException(super.message, {super.code, super.details});
}

/// Exception for insufficient funds
class InsufficientFundsException extends YukuException {
  const InsufficientFundsException(super.message, {super.code, super.details});
}

/// Exception for invalid address
class InvalidAddressException extends YukuException {
  const InvalidAddressException(super.message, {super.code, super.details});
}

/// Exception for invalid transaction
class InvalidTransactionException extends YukuException {
  const InvalidTransactionException(super.message, {super.code, super.details});
}

/// Exception for contract operations
class ContractException extends YukuException {
  const ContractException(super.message, {super.code, super.details});
}

/// Exception for metadata operations
class MetadataException extends YukuException {
  const MetadataException(super.message, {super.code, super.details});
}

/// Exception for IPFS operations
class IPFSException extends YukuException {
  const IPFSException(super.message, {super.code, super.details});
}

/// Exception for rate limiting
class RateLimitException extends YukuException {
  const RateLimitException(super.message, {super.code, super.details});
}

/// Exception for unsupported operations
class UnsupportedOperationException extends YukuException {
  const UnsupportedOperationException(
    super.message, {
    super.code,
    super.details,
  });
}

/// Exception for wallet not connected
class WalletNotConnectedException extends WalletOperationException {
  const WalletNotConnectedException(super.message, {super.code, super.details});
}

