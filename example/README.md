# Flutter Yuku Example

This example app demonstrates all the functionality of the `flutter_yuku` library - a universal Flutter library for blockchain operations across multiple networks.

## Features Demonstrated

### 1. Client Information & Utils Tab
- **Client Status**: Shows initialization status and version
- **Network Configuration**: Displays configured blockchain networks (Ethereum, Solana, Polygon, ICP)
- **Utility Functions**:
  - Address validation for different blockchain networks (Ethereum, Solana, ICP)
  - Price formatting with currency symbols
  - Address formatting for display
  - Network display names

### 2. Wallet Operations Tab
- **Address Validation**: Validate wallet addresses for different networks
- **Balance Check**: Demo balance checking functionality
- **Send Transaction**: Demo transaction sending with formatted output
- **Network Selection**: Switch between different blockchain networks

### 3. NFT Operations Tab
- **NFT Collection Display**: Shows demo NFT collection with:
  - NFT name and description
  - Network information with color coding
  - Owner and creator addresses
  - Current value and currency
  - Rarity levels
- **NFT Details**: View detailed information about each NFT:
  - Token ID and contract address
  - Metadata attributes
  - Transaction history
  - Transferability status
  - Creation date

### 4. Marketplace Operations Tab
- **Active Listings**: View NFT listings across different networks
- **Create Listing**: Demo functionality to create new NFT listings
- **Buy NFT**: Demo purchase functionality
- **Listing Details**: View comprehensive listing information:
  - Price and currency
  - Seller and buyer addresses
  - Listing status (active, sold, cancelled, expired)
  - Creation and expiration dates

## Supported Networks

The example demonstrates support for:
- **Ethereum**: With ETH as native currency
- **Solana**: With SOL as native currency
- **Polygon**: With MATIC as native currency
- **Internet Computer (ICP)**: With ICP as native currency

## Running the Example

### Prerequisites
- Flutter SDK >= 3.24.0
- Dart SDK >= 3.8.0

### Installation

```bash
cd example
flutter pub get
```

### Run on Different Platforms

The example app supports **ALL platforms**! 🎉

**Android:**
```bash
flutter run -d android
```

**iOS:**
```bash
flutter run -d ios
```

**Web:**
```bash
flutter run -d chrome
```

**macOS:**
```bash
flutter run -d macos
```

**Windows:**
```bash
flutter run -d windows
```

**Linux:**
```bash
flutter run -d linux
```

See [PLATFORMS.md](PLATFORMS.md) for detailed platform-specific instructions.

## Code Structure

The example app is organized into four main tabs, each demonstrating different aspects of the library:

1. **ClientInfoTab**: Client initialization and utility functions
2. **WalletTab**: Wallet operations and transactions
3. **NFTTab**: NFT display and management
4. **MarketplaceTab**: Marketplace listings and trading

## Demo Data

The app uses demo data for demonstration purposes:
- 3 demo NFTs across different networks
- 3 demo marketplace listings
- Simulated wallet balances and transactions

All operations are demos and don't interact with real blockchain networks.

## Key Features

### Network Support
- Multi-network architecture
- Network-specific address validation
- Network-specific currency handling

### NFT Management
- Comprehensive NFT metadata
- Rarity levels (Common, Uncommon, Rare, Epic, Legendary, Mythic)
- Attribute and property management

### Marketplace
- Listing creation and management
- Offer system
- Purchase functionality
- Status tracking (active, sold, cancelled, expired)

### Utilities
- Address validation and formatting
- Price formatting
- Network information
- Transaction hash generation

## Learn More

For more information about the `flutter_yuku` library, see the main README in the parent directory.

