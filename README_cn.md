# Flutter Yuku

<div align="center">

### 🌍 [English](README.md) | [Русский](README_ru.md) | [ไทย](README_th.md) | [中文](README_cn.md)

[![pub package](https://img.shields.io/pub/v/flutter_yuku.svg)](https://pub.dev/packages/flutter_yuku)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

## 📱 截图

<div align="center">
  <img src="screenshots/nft_yuku_1.png" width="200" />
  <img src="screenshots/nft_yuku_2.png" width="200" />
  <img src="screenshots/nft_yuku_3.png" width="200" />
  <img src="screenshots/nft_yuku_4.png" width="200" />
</div>

---

跨多个网络的区块链操作通用 Flutter 库。Flutter Yuku 为跨不同区块链网络处理 NFT、钱包和市场操作提供统一接口。

## 功能特点

- 🌐 **多区块链支持**: Ethereum、Solana、Polygon、BSC、Avalanche、ICP、NEAR、TRON
- 🎨 **NFT 操作**: 铸造、转移、销毁、批准和管理 NFT
- 💰 **钱包集成**: 跨不同网络连接和管理钱包
- 🏪 **市场支持**: 上架、购买、出售和管理 NFT 市场操作
- 🔧 **统一 API**: 所有区块链操作的单一接口
- 📱 **Flutter 小部件**: 用于 NFT 和钱包操作的即用型 UI 组件
- 🛡️ **类型安全**: Dart 类型系统的完全类型安全
- 🚀 **性能**: 针对移动和 Web 应用程序进行优化

## 支持的网络

- **Ethereum** - 完全支持 ERC-721 和 ERC-1155
- **Solana** - SPL Token 和 Metaplex 支持
- **Polygon** - Ethereum Layer 2 扩展
- **BSC** - 币安智能链
- **Avalanche** - C-Chain 支持
- **ICP** - Internet Computer Protocol
- **NEAR** - NEAR Protocol
- **TRON** - TRON 区块链

## 安装

将 `flutter_yuku` 添加到您的 `pubspec.yaml`:

```yaml
dependencies:
  flutter_yuku: ^1.0.0
```

然后运行:

```bash
flutter pub get
```

## 快速开始

### 1. 初始化客户端

```dart
import 'package:flutter_yuku/flutter_yuku.dart';

final client = YukuClient();
await client.initialize();
```

### 2. 获取 NFT 提供者

```dart
// 获取 Ethereum 提供者
final ethereumProvider = client.getNFTProvider(BlockchainNetwork.ethereum);

// 获取 ICP 提供者
final icpProvider = client.getNFTProvider(BlockchainNetwork.icp);
```

### 3. 基本 NFT 操作

```dart
// 获取地址拥有的 NFT
final nfts = await ethereumProvider.getNFTsByOwner('0x...');

// 获取特定 NFT
final nft = await ethereumProvider.getNFT('1', '0x...');

// 铸造新 NFT
final transactionHash = await ethereumProvider.mintNFT(
  toAddress: '0x...',
  metadata: NFTMetadata(
    name: '我的 NFT',
    description: '一个漂亮的 NFT',
    image: 'https://example.com/image.png',
  ),
  contractAddress: '0x...',
);
```

### 4. 钱包操作

```dart
// 获取钱包提供者
final walletProvider = client.getWalletProvider(BlockchainNetwork.ethereum);

// 连接钱包
await walletProvider.connect();

// 获取余额
final balance = await walletProvider.getBalance('0x...');

// 发送交易
final txHash = await walletProvider.sendTransaction(
  to: '0x...',
  amount: 0.1,
  currency: 'ETH',
);
```

### 5. 市场操作

```dart
// 获取市场提供者
final marketplaceProvider = client.getMarketplaceProvider(BlockchainNetwork.ethereum);

// 上架 NFT 出售
final listingId = await marketplaceProvider.listNFT(
  tokenId: '1',
  contractAddress: '0x...',
  price: 1.0,
  currency: 'ETH',
);

// 购买 NFT
final purchaseTx = await marketplaceProvider.buyNFT(listingId);
```

## 核心组件

### YukuClient

管理所有提供者和操作的主客户端。

```dart
final client = YukuClient();

// 使用特定提供者初始化
await client.initialize();

// 获取支持的网络
final networks = client.getSupportedNetworks();

// 检查是否支持网络
final isSupported = client.isNetworkSupported(BlockchainNetwork.ethereum);
```

### NFTProvider

跨不同区块链的 NFT 操作接口。

```dart
abstract class NFTProvider {
  Future<List<NFT>> getNFTsByOwner(String ownerAddress);
  Future<NFT?> getNFT(String tokenId, String contractAddress);
  Future<String> mintNFT({...});
  Future<String> transferNFT({...});
  Future<String> burnNFT({...});
  // ... 更多方法
}
```

### WalletProvider

钱包操作接口。

```dart
abstract class WalletProvider {
  Future<void> connect();
  Future<void> disconnect();
  Future<double> getBalance(String address);
  Future<String> sendTransaction({...});
  // ... 更多方法
}
```

### MarketplaceProvider

市场操作接口。

```dart
abstract class MarketplaceProvider {
  Future<String> listNFT({...});
  Future<String> buyNFT(String listingId);
  Future<String> cancelListing(String listingId);
  Future<List<Listing>> getListings({...});
  // ... 更多方法
}
```

## 模型

### NFT

适用于所有支持网络的通用 NFT 模型。

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

标准化元数据格式。

```dart
class NFTMetadata {
  final String name;
  final String description;
  final String image;
  final Map<String, dynamic> attributes;
  final Map<String, dynamic> properties;
}
```

## 小部件

### YukuWalletWidget

即用型钱包连接小部件。

```dart
YukuWalletWidget(
  onConnected: (address) {
    print('已连接: $address');
  },
  onDisconnected: () {
    print('已断开连接');
  },
)
```

### YukuNFTWidget

显示 NFT 信息。

```dart
YukuNFTWidget(
  nft: nft,
  onTap: () {
    // 处理 NFT 点击
  },
)
```

### YukuMarketplaceWidget

市场界面小部件。

```dart
YukuMarketplaceWidget(
  onNFTSelected: (nft) {
    // 处理 NFT 选择
  },
  onBuyNFT: (listingId) {
    // 处理 NFT 购买
  },
)
```

## 配置

### 网络配置

```dart
// 配置 Ethereum 主网
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

// 配置 ICP 主网
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

### 提供者配置

```dart
// 注册自定义提供者
client.registerNFTProvider(CustomNFTProvider());

// 为网络设置默认提供者
client.setDefaultProvider(BlockchainNetwork.ethereum, 'custom-provider');
```

## 错误处理

```dart
try {
  final nfts = await provider.getNFTsByOwner(address);
} on NFTOperationException catch (e) {
  print('NFT 操作失败: ${e.message}');
} on NetworkException catch (e) {
  print('网络错误: ${e.message}');
} catch (e) {
  print('意外错误: $e');
}
```

## 示例

查看 `example/` 目录获取完整示例:

- **基本 NFT 操作**: 铸造、转移和管理 NFT
- **钱包集成**: 连接钱包和管理余额
- **市场**: 上架和购买 NFT
- **多网络**: 使用多个区块链网络

## 贡献

我们欢迎贡献！请查看我们的[贡献指南](CONTRIBUTING.md)了解详情。

## 许可证

本项目根据 MIT 许可证授权 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 支持

- 📖 [文档](https://github.com/libsFlutter/flutter_yuku/wiki)
- 🐛 [问题跟踪](https://github.com/libsFlutter/flutter_yuku/issues)
- 💬 [讨论](https://github.com/libsFlutter/flutter_yuku/discussions)

## 更新日志

查看 [CHANGELOG.md](CHANGELOG.md) 了解更改列表和版本历史。

