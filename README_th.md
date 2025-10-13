# Flutter Yuku

<div align="center">

### 🌍 [English](README.md) | [Русский](README_ru.md) | [ไทย](README_th.md) | [中文](README_cn.md)

[![pub package](https://img.shields.io/pub/v/flutter_yuku.svg)](https://pub.dev/packages/flutter_yuku)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

</div>

## 📱 ภาพหน้าจอ

<div align="center">
  <img src="screenshots/nft_yuku_1.png" width="200" />
  <img src="screenshots/nft_yuku_2.png" width="200" />
  <img src="screenshots/nft_yuku_3.png" width="200" />
  <img src="screenshots/nft_yuku_4.png" width="200" />
</div>

---

ไลบรารี Flutter สากลสำหรับการดำเนินการบล็อกเชนข้ามหลายเครือข่าย Flutter Yuku ให้อินเทอร์เฟซที่เป็นหนึ่งเดียวสำหรับการทำงานกับ NFT กระเป๋าเงิน และการดำเนินการของตลาดซื้อขายข้ามเครือข่ายบล็อกเชนต่างๆ

## ฟีเจอร์

- 🌐 **รองรับหลายบล็อกเชน**: Ethereum, Solana, Polygon, BSC, Avalanche, ICP, NEAR, TRON
- 🎨 **การดำเนินการ NFT**: สร้าง โอน เบิร์น อนุมัติ และจัดการ NFT
- 💰 **การรวมกระเป๋าเงิน**: เชื่อมต่อและจัดการกระเป๋าเงินข้ามเครือข่ายต่างๆ
- 🏪 **รองรับตลาดซื้อขาย**: ลิสต์ ซื้อ ขาย และจัดการการดำเนินการของตลาดซื้อขาย NFT
- 🔧 **API เดียวครบ**: อินเทอร์เฟซเดียวสำหรับการดำเนินการบล็อกเชนทั้งหมด
- 📱 **วิดเจ็ต Flutter**: คอมโพเนนต์ UI พร้อมใช้สำหรับ NFT และการดำเนินการกระเป๋าเงิน
- 🛡️ **ความปลอดภัยของประเภท**: ความปลอดภัยของประเภทเต็มรูปแบบด้วยระบบประเภทของ Dart
- 🚀 **ประสิทธิภาพ**: ปรับให้เหมาะกับแอปพลิเคชันมือถือและเว็บ

## เครือข่ายที่รองรับ

- **Ethereum** - รองรับ ERC-721 และ ERC-1155 เต็มรูปแบบ
- **Solana** - รองรับ SPL Token และ Metaplex
- **Polygon** - การขยายขนาด Layer 2 ของ Ethereum
- **BSC** - Binance Smart Chain
- **Avalanche** - รองรับ C-Chain
- **ICP** - Internet Computer Protocol
- **NEAR** - NEAR Protocol
- **TRON** - บล็อกเชน TRON

## การติดตั้ง

เพิ่ม `flutter_yuku` ใน `pubspec.yaml` ของคุณ:

```yaml
dependencies:
  flutter_yuku: ^1.0.0
```

จากนั้นรัน:

```bash
flutter pub get
```

## เริ่มต้นอย่างรวดเร็ว

### 1. เริ่มต้นไคลเอ็นต์

```dart
import 'package:flutter_yuku/flutter_yuku.dart';

final client = YukuClient();
await client.initialize();
```

### 2. รับ NFT Provider

```dart
// รับ provider สำหรับ Ethereum
final ethereumProvider = client.getNFTProvider(BlockchainNetwork.ethereum);

// รับ provider สำหรับ ICP
final icpProvider = client.getNFTProvider(BlockchainNetwork.icp);
```

### 3. การดำเนินการ NFT พื้นฐาน

```dart
// รับ NFT ที่เป็นเจ้าของโดยที่อยู่
final nfts = await ethereumProvider.getNFTsByOwner('0x...');

// รับ NFT เฉพาะ
final nft = await ethereumProvider.getNFT('1', '0x...');

// สร้าง NFT ใหม่
final transactionHash = await ethereumProvider.mintNFT(
  toAddress: '0x...',
  metadata: NFTMetadata(
    name: 'NFT ของฉัน',
    description: 'NFT ที่สวยงาม',
    image: 'https://example.com/image.png',
  ),
  contractAddress: '0x...',
);
```

### 4. การดำเนินการกระเป๋าเงิน

```dart
// รับ provider กระเป๋าเงิน
final walletProvider = client.getWalletProvider(BlockchainNetwork.ethereum);

// เชื่อมต่อกระเป๋าเงิน
await walletProvider.connect();

// รับยอดคงเหลือ
final balance = await walletProvider.getBalance('0x...');

// ส่งธุรกรรม
final txHash = await walletProvider.sendTransaction(
  to: '0x...',
  amount: 0.1,
  currency: 'ETH',
);
```

### 5. การดำเนินการของตลาดซื้อขาย

```dart
// รับ provider ตลาดซื้อขาย
final marketplaceProvider = client.getMarketplaceProvider(BlockchainNetwork.ethereum);

// ลิสต์ NFT เพื่อขาย
final listingId = await marketplaceProvider.listNFT(
  tokenId: '1',
  contractAddress: '0x...',
  price: 1.0,
  currency: 'ETH',
);

// ซื้อ NFT
final purchaseTx = await marketplaceProvider.buyNFT(listingId);
```

## คอมโพเนนต์หลัก

### YukuClient

ไคลเอ็นต์หลักที่จัดการ provider และการดำเนินการทั้งหมด

```dart
final client = YukuClient();

// เริ่มต้นด้วย provider เฉพาะ
await client.initialize();

// รับเครือข่ายที่รองรับ
final networks = client.getSupportedNetworks();

// ตรวจสอบว่ารองรับเครือข่ายหรือไม่
final isSupported = client.isNetworkSupported(BlockchainNetwork.ethereum);
```

### NFTProvider

อินเทอร์เฟซสำหรับการดำเนินการ NFT ข้ามบล็อกเชนต่างๆ

```dart
abstract class NFTProvider {
  Future<List<NFT>> getNFTsByOwner(String ownerAddress);
  Future<NFT?> getNFT(String tokenId, String contractAddress);
  Future<String> mintNFT({...});
  Future<String> transferNFT({...});
  Future<String> burnNFT({...});
  // ... เมธอดอื่นๆ
}
```

### WalletProvider

อินเทอร์เฟซสำหรับการดำเนินการกระเป๋าเงิน

```dart
abstract class WalletProvider {
  Future<void> connect();
  Future<void> disconnect();
  Future<double> getBalance(String address);
  Future<String> sendTransaction({...});
  // ... เมธอดอื่นๆ
}
```

### MarketplaceProvider

อินเทอร์เฟซสำหรับการดำเนินการของตลาดซื้อขาย

```dart
abstract class MarketplaceProvider {
  Future<String> listNFT({...});
  Future<String> buyNFT(String listingId);
  Future<String> cancelListing(String listingId);
  Future<List<Listing>> getListings({...});
  // ... เมธอดอื่นๆ
}
```

## โมเดล

### NFT

โมเดล NFT สากลที่ทำงานได้กับทุกเครือข่ายที่รองรับ

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

รูปแบบเมทาดาทาที่เป็นมาตรฐาน

```dart
class NFTMetadata {
  final String name;
  final String description;
  final String image;
  final Map<String, dynamic> attributes;
  final Map<String, dynamic> properties;
}
```

## วิดเจ็ต

### YukuWalletWidget

วิดเจ็ตการเชื่อมต่อกระเป๋าเงินพร้อมใช้

```dart
YukuWalletWidget(
  onConnected: (address) {
    print('เชื่อมต่อแล้ว: $address');
  },
  onDisconnected: () {
    print('ตัดการเชื่อมต่อแล้ว');
  },
)
```

### YukuNFTWidget

แสดงข้อมูล NFT

```dart
YukuNFTWidget(
  nft: nft,
  onTap: () {
    // จัดการการแตะ NFT
  },
)
```

### YukuMarketplaceWidget

วิดเจ็ตอินเทอร์เฟซตลาดซื้อขาย

```dart
YukuMarketplaceWidget(
  onNFTSelected: (nft) {
    // จัดการการเลือก NFT
  },
  onBuyNFT: (listingId) {
    // จัดการการซื้อ NFT
  },
)
```

## การกำหนดค่า

### การกำหนดค่าเครือข่าย

```dart
// กำหนดค่า Ethereum mainnet
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

// กำหนดค่า ICP mainnet
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

### การกำหนดค่า Provider

```dart
// ลงทะเบียน provider ที่กำหนดเอง
client.registerNFTProvider(CustomNFTProvider());

// ตั้งค่า provider เริ่มต้นสำหรับเครือข่าย
client.setDefaultProvider(BlockchainNetwork.ethereum, 'custom-provider');
```

## การจัดการข้อผิดพลาด

```dart
try {
  final nfts = await provider.getNFTsByOwner(address);
} on NFTOperationException catch (e) {
  print('การดำเนินการ NFT ล้มเหลว: ${e.message}');
} on NetworkException catch (e) {
  print('ข้อผิดพลาดเครือข่าย: ${e.message}');
} catch (e) {
  print('ข้อผิดพลาดที่ไม่คาดคิด: $e');
}
```

## ตัวอย่าง

ดูไดเรกทอรี `example/` สำหรับตัวอย่างที่สมบูรณ์:

- **การดำเนินการ NFT พื้นฐาน**: สร้าง โอน และจัดการ NFT
- **การรวมกระเป๋าเงิน**: เชื่อมต่อกระเป๋าเงินและจัดการยอดคงเหลือ
- **ตลาดซื้อขาย**: ลิสต์และซื้อ NFT
- **หลายเครือข่าย**: ทำงานกับหลายเครือข่ายบล็อกเชน

## การมีส่วนร่วม

เรายินดีรับการมีส่วนร่วม! โปรดดู[คู่มือการมีส่วนร่วม](CONTRIBUTING.md) ของเราสำหรับรายละเอียด

## ใบอนุญาต

โปรเจคนี้ได้รับอนุญาตภายใต้ใบอนุญาต MIT - ดูไฟล์ [LICENSE](LICENSE) สำหรับรายละเอียด

## การสนับสนุน

- 📖 [เอกสาร](https://github.com/libsFlutter/flutter_yuku/wiki)
- 🐛 [ติดตามปัญหา](https://github.com/libsFlutter/flutter_yuku/issues)
- 💬 [การสนทนา](https://github.com/libsFlutter/flutter_yuku/discussions)

## บันทึกการเปลี่ยนแปลง

ดู [CHANGELOG.md](CHANGELOG.md) สำหรับรายการการเปลี่ยนแปลงและประวัติเวอร์ชัน

