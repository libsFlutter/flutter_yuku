# Flutter Yuku

<div align="center">

### 🌍 [English](README.md) | [Русский](README_ru.md) | [ไทย](README_th.md) | [中文](README_cn.md)

[![pub package](https://img.shields.io/pub/v/flutter_yuku.svg)](https://pub.dev/packages/flutter_yuku)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

## 📱 Скриншоты

<div align="center">
  <img src="screenshots/nft_yuku_1.png" width="200" />
  <img src="screenshots/nft_yuku_2.png" width="200" />
  <img src="screenshots/nft_yuku_3.png" width="200" />
  <img src="screenshots/nft_yuku_4.png" width="200" />
</div>

---

Универсальная библиотека Flutter для работы с блокчейн операциями на различных сетях. Flutter Yuku предоставляет унифицированный интерфейс для работы с NFT, кошельками и операциями маркетплейса на разных блокчейн сетях.

## Возможности

- 🌐 **Поддержка мультиблокчейн**: Ethereum, Solana, Polygon, BSC, Avalanche, ICP, NEAR, TRON
- 🎨 **Операции с NFT**: Создание, передача, сжигание, одобрение и управление NFT
- 💰 **Интеграция кошельков**: Подключение и управление кошельками на разных сетях
- 🏪 **Поддержка маркетплейса**: Размещение, покупка, продажа и управление NFT на маркетплейсе
- 🔧 **Единый API**: Единый интерфейс для всех блокчейн операций
- 📱 **Flutter виджеты**: Готовые UI компоненты для NFT и операций с кошельком
- 🛡️ **Типобезопасность**: Полная типобезопасность с системой типов Dart
- 🚀 **Производительность**: Оптимизировано для мобильных и веб приложений

## Поддерживаемые сети

- **Ethereum** - Полная поддержка ERC-721 и ERC-1155
- **Solana** - Поддержка SPL Token и Metaplex
- **Polygon** - Layer 2 масштабирование Ethereum
- **BSC** - Binance Smart Chain
- **Avalanche** - Поддержка C-Chain
- **ICP** - Internet Computer Protocol
- **NEAR** - NEAR Protocol
- **TRON** - TRON блокчейн

## Установка

Добавьте `flutter_yuku` в ваш `pubspec.yaml`:

```yaml
dependencies:
  flutter_yuku: ^1.0.0
```

Затем выполните:

```bash
flutter pub get
```

## Быстрый старт

### 1. Инициализация клиента

```dart
import 'package:flutter_yuku/flutter_yuku.dart';

final client = YukuClient();
await client.initialize();
```

### 2. Получение NFT провайдера

```dart
// Получить провайдер для Ethereum
final ethereumProvider = client.getNFTProvider(BlockchainNetwork.ethereum);

// Получить провайдер для ICP
final icpProvider = client.getNFTProvider(BlockchainNetwork.icp);
```

### 3. Базовые операции с NFT

```dart
// Получить NFT, принадлежащие адресу
final nfts = await ethereumProvider.getNFTsByOwner('0x...');

// Получить конкретный NFT
final nft = await ethereumProvider.getNFT('1', '0x...');

// Создать новый NFT
final transactionHash = await ethereumProvider.mintNFT(
  toAddress: '0x...',
  metadata: NFTMetadata(
    name: 'Мой NFT',
    description: 'Красивый NFT',
    image: 'https://example.com/image.png',
  ),
  contractAddress: '0x...',
);
```

### 4. Операции с кошельком

```dart
// Получить провайдер кошелька
final walletProvider = client.getWalletProvider(BlockchainNetwork.ethereum);

// Подключить кошелек
await walletProvider.connect();

// Получить баланс
final balance = await walletProvider.getBalance('0x...');

// Отправить транзакцию
final txHash = await walletProvider.sendTransaction(
  to: '0x...',
  amount: 0.1,
  currency: 'ETH',
);
```

### 5. Операции маркетплейса

```dart
// Получить провайдер маркетплейса
final marketplaceProvider = client.getMarketplaceProvider(BlockchainNetwork.ethereum);

// Выставить NFT на продажу
final listingId = await marketplaceProvider.listNFT(
  tokenId: '1',
  contractAddress: '0x...',
  price: 1.0,
  currency: 'ETH',
);

// Купить NFT
final purchaseTx = await marketplaceProvider.buyNFT(listingId);
```

## Основные компоненты

### YukuClient

Главный клиент, который управляет всеми провайдерами и операциями.

```dart
final client = YukuClient();

// Инициализация с конкретными провайдерами
await client.initialize();

// Получить поддерживаемые сети
final networks = client.getSupportedNetworks();

// Проверить, поддерживается ли сеть
final isSupported = client.isNetworkSupported(BlockchainNetwork.ethereum);
```

### NFTProvider

Интерфейс для операций с NFT на разных блокчейнах.

```dart
abstract class NFTProvider {
  Future<List<NFT>> getNFTsByOwner(String ownerAddress);
  Future<NFT?> getNFT(String tokenId, String contractAddress);
  Future<String> mintNFT({...});
  Future<String> transferNFT({...});
  Future<String> burnNFT({...});
  // ... другие методы
}
```

### WalletProvider

Интерфейс для операций с кошельком.

```dart
abstract class WalletProvider {
  Future<void> connect();
  Future<void> disconnect();
  Future<double> getBalance(String address);
  Future<String> sendTransaction({...});
  // ... другие методы
}
```

### MarketplaceProvider

Интерфейс для операций маркетплейса.

```dart
abstract class MarketplaceProvider {
  Future<String> listNFT({...});
  Future<String> buyNFT(String listingId);
  Future<String> cancelListing(String listingId);
  Future<List<Listing>> getListings({...});
  // ... другие методы
}
```

## Модели

### NFT

Универсальная модель NFT, которая работает на всех поддерживаемых сетях.

```dart
class NFT {
  final String id;
  final String tokenId;
  final String contractAddress;
  final BlockchainNetwork network;
  final NFTMetadata metadata;
  final String owner;
  final String creator;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final double? currentValue;
  final String? valueCurrency;
  final List<String> transactionHistory;
  final Map<String, dynamic> additionalProperties;
}
```

### NFTMetadata

Стандартизированный формат метаданных.

```dart
class NFTMetadata {
  final String name;
  final String description;
  final String image;
  final Map<String, dynamic> attributes;
  final Map<String, dynamic> properties;
}
```

## Виджеты

### YukuWalletWidget

Готовый виджет для подключения кошелька.

```dart
YukuWalletWidget(
  onConnected: (address) {
    print('Подключено: $address');
  },
  onDisconnected: () {
    print('Отключено');
  },
)
```

### YukuNFTWidget

Отображение информации о NFT.

```dart
YukuNFTWidget(
  nft: nft,
  onTap: () {
    // Обработка нажатия на NFT
  },
)
```

### YukuMarketplaceWidget

Виджет интерфейса маркетплейса.

```dart
YukuMarketplaceWidget(
  onNFTSelected: (nft) {
    // Обработка выбора NFT
  },
  onBuyNFT: (listingId) {
    // Обработка покупки NFT
  },
)
```

## Конфигурация

### Конфигурация сети

```dart
// Настройка Ethereum mainnet
client.setNetworkConfig(
  BlockchainNetwork.ethereum,
  NetworkConfig(
    name: 'Ethereum Mainnet',
    rpcUrl: 'https://mainnet.infura.io/v3/YOUR_KEY',
    chainId: '1',
    network: BlockchainNetwork.ethereum,
    isTestnet: false,
  ),
);

// Настройка ICP mainnet
client.setNetworkConfig(
  BlockchainNetwork.icp,
  NetworkConfig(
    name: 'ICP Mainnet',
    rpcUrl: 'https://ic0.app',
    chainId: 'icp',
    network: BlockchainNetwork.icp,
    isTestnet: false,
  ),
);
```

### Конфигурация провайдера

```dart
// Регистрация пользовательского провайдера
client.registerNFTProvider(CustomNFTProvider());

// Установка провайдера по умолчанию для сети
client.setDefaultProvider(BlockchainNetwork.ethereum, 'custom-provider');
```

## Обработка ошибок

```dart
try {
  final nfts = await provider.getNFTsByOwner(address);
} on NFTOperationException catch (e) {
  print('Операция NFT не удалась: ${e.message}');
} on NetworkException catch (e) {
  print('Ошибка сети: ${e.message}');
} catch (e) {
  print('Неожиданная ошибка: $e');
}
```

## Примеры

Смотрите директорию `example/` для полных примеров:

- **Базовые операции с NFT**: Создание, передача и управление NFT
- **Интеграция кошелька**: Подключение кошельков и управление балансами
- **Маркетплейс**: Размещение и покупка NFT
- **Мультисеть**: Работа с несколькими блокчейн сетями

## Вклад в проект

Мы приветствуем вклад! Пожалуйста, ознакомьтесь с нашим [Руководством по внесению вклада](CONTRIBUTING.md).

## Лицензия

Этот проект лицензирован под лицензией MIT - смотрите файл [LICENSE](LICENSE) для подробностей.

## Поддержка

- 📖 [Документация](https://github.com/libsFlutter/flutter_yuku/wiki)
- 🐛 [Трекер проблем](https://github.com/libsFlutter/flutter_yuku/issues)
- 💬 [Обсуждения](https://github.com/libsFlutter/flutter_yuku/discussions)

## Журнал изменений

Смотрите [CHANGELOG.md](CHANGELOG.md) для списка изменений и истории версий.

