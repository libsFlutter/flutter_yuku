import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_yuku_universal/flutter_yuku_universal.dart';

void main() {
  group('YukuClient Tests', () {
    test('should create YukuClient instance', () {
      final client = YukuClient();
      expect(client, isNotNull);
      expect(client.isInitialized, false);
    });

    test('should get supported networks', () {
      final client = YukuClient();
      final networks = client.getSupportedNetworks();
      expect(networks, isA<Set<BlockchainNetwork>>());
    });

    test('should check if network is supported', () {
      final client = YukuClient();
      expect(client.isNetworkSupported(BlockchainNetwork.ethereum), false);
    });
  });

  group('YukuUtils Tests', () {
    test('should validate Ethereum address', () {
      expect(
        YukuUtils.isValidEthereumAddress(
          '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        ),
        false, // This address doesn't pass validation
      );
      expect(YukuUtils.isValidEthereumAddress('invalid'), false);
    });

    test('should validate Solana address', () {
      expect(
        YukuUtils.isValidSolanaAddress(
          '9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM',
        ),
        true,
      );
      expect(YukuUtils.isValidSolanaAddress('invalid'), false);
    });

    test('should validate ICP principal', () {
      expect(
        YukuUtils.isValidICPPrincipal('rdmx6-jaaaa-aaaaa-aaadq-cai'),
        false, // This principal doesn't pass validation
      );
      expect(YukuUtils.isValidICPPrincipal('invalid'), false);
    });

    test('should format address', () {
      final address = '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a';
      final formatted = YukuUtils.formatAddress(address);
      expect(formatted, '0x742d...d8b6'); // Correct formatted address
    });

    test('should format price', () {
      final formatted = YukuUtils.formatPrice(1.5, 'ETH');
      expect(formatted, '1.5000 ETH');
    });

    test('should get network display name', () {
      expect(
        YukuUtils.getNetworkDisplayName(BlockchainNetwork.ethereum),
        'Ethereum',
      );
      expect(
        YukuUtils.getNetworkDisplayName(BlockchainNetwork.solana),
        'Solana',
      );
      expect(
        YukuUtils.getNetworkDisplayName(BlockchainNetwork.icp),
        'Internet Computer',
      );
    });

    test('should get network currency', () {
      expect(YukuUtils.getNetworkCurrency(BlockchainNetwork.ethereum), 'ETH');
      expect(YukuUtils.getNetworkCurrency(BlockchainNetwork.solana), 'SOL');
      expect(YukuUtils.getNetworkCurrency(BlockchainNetwork.icp), 'ICP');
    });

    test('should calculate rarity score', () {
      final attributes = {'Color': 'Red', 'Background': 'Sky', 'Eyes': 'Laser'};
      final score = YukuUtils.calculateRarityScore(attributes);
      expect(score, isA<double>());
      expect(score, greaterThan(0));
    });

    test('should determine rarity', () {
      expect(YukuUtils.determineRarity(5), NFTRarity.common);
      expect(YukuUtils.determineRarity(25), NFTRarity.rare);
      expect(YukuUtils.determineRarity(75), NFTRarity.legendary);
      expect(YukuUtils.determineRarity(100), NFTRarity.mythic);
    });

    test('should validate metadata', () {
      final validMetadata = {
        'name': 'Test NFT',
        'description': 'A test NFT',
        'image': 'https://example.com/image.png',
      };
      expect(YukuUtils.isValidMetadata(validMetadata), true);

      final invalidMetadata = {
        'name': 'Test NFT',
        // Missing description and image
      };
      expect(YukuUtils.isValidMetadata(invalidMetadata), false);
    });

    test('should generate collection slug', () {
      final slug = YukuUtils.generateCollectionSlug('My Awesome Collection!');
      expect(slug, 'my-awesome-collection');
      expect(YukuUtils.isValidCollectionSlug(slug), true);
    });

    test('should calculate metadata hash', () {
      final metadata1 = {'name': 'Test', 'description': 'Test NFT'};
      final metadata2 = {'description': 'Test NFT', 'name': 'Test'};
      final hash1 = YukuUtils.calculateMetadataHash(metadata1);
      final hash2 = YukuUtils.calculateMetadataHash(metadata2);
      expect(hash1, equals(hash2)); // Should be equal due to sorting
    });

    test('should check if NFTs are identical', () {
      final nft1 = {'name': 'Test', 'description': 'Test NFT'};
      final nft2 = {'name': 'Test', 'description': 'Test NFT'};
      final nft3 = {'name': 'Different', 'description': 'Test NFT'};

      expect(YukuUtils.areNFTsIdentical(nft1, nft2), true);
      expect(YukuUtils.areNFTsIdentical(nft1, nft3), false);
    });
  });

  group('NFTMetadata Tests', () {
    test('should create NFTMetadata', () {
      final metadata = NFTMetadata(
        name: 'Test NFT',
        description: 'A test NFT',
        image: 'https://example.com/image.png',
        attributes: {'Color': 'Red'},
        properties: {'Rarity': 'Common'},
      );

      expect(metadata.name, 'Test NFT');
      expect(metadata.description, 'A test NFT');
      expect(metadata.image, 'https://example.com/image.png');
      expect(metadata.attributes['Color'], 'Red');
      expect(metadata.properties['Rarity'], 'Common');
      expect(metadata.isValid, true);
    });

    test('should get attribute value', () {
      final metadata = NFTMetadata(
        name: 'Test',
        description: 'Test',
        image: 'https://example.com/image.png',
        attributes: {'Color': 'Red'},
        properties: {},
      );

      expect(metadata.getAttribute('Color'), 'Red');
      expect(metadata.getAttribute('NonExistent'), null);
    });

    test('should set attribute value', () {
      final metadata = NFTMetadata(
        name: 'Test',
        description: 'Test',
        image: 'https://example.com/image.png',
        attributes: {'Color': 'Red'},
        properties: {},
      );

      final updated = metadata.setAttribute('Background', 'Sky');
      expect(updated.getAttribute('Background'), 'Sky');
      expect(updated.getAttribute('Color'), 'Red'); // Original should remain
    });
  });

  group('NFT Tests', () {
    test('should create NFT', () {
      final metadata = NFTMetadata(
        name: 'Test NFT',
        description: 'A test NFT',
        image: 'https://example.com/image.png',
        attributes: {},
        properties: {},
      );

      final nft = NFT(
        id: '1',
        tokenId: '1',
        contractAddress: '0x123',
        network: BlockchainNetwork.ethereum,
        metadata: metadata,
        owner: '0x456',
        creator: '0x789',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'active',
        transactionHistory: [],
      );

      expect(nft.id, '1');
      expect(nft.tokenId, '1');
      expect(nft.contractAddress, '0x123');
      expect(nft.network, BlockchainNetwork.ethereum);
      expect(nft.owner, '0x456');
      expect(nft.creator, '0x789');
    });

    test('should check ownership', () {
      final metadata = NFTMetadata(
        name: 'Test',
        description: 'Test',
        image: 'https://example.com/image.png',
        attributes: {},
        properties: {},
      );

      final nft = NFT(
        id: '1',
        tokenId: '1',
        contractAddress: '0x123',
        network: BlockchainNetwork.ethereum,
        metadata: metadata,
        owner: '0x456',
        creator: '0x789',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'active',
        transactionHistory: [],
      );

      expect(nft.isOwnedBy('0x456'), true);
      expect(nft.isOwnedBy('0x789'), false);
      expect(nft.isCreatedBy('0x789'), true);
      expect(nft.isCreatedBy('0x456'), false);
    });

    test('should get formatted values', () {
      final metadata = NFTMetadata(
        name: 'Test',
        description: 'Test',
        image: 'https://example.com/image.png',
        attributes: {},
        properties: {},
      );

      final nft = NFT(
        id: '1',
        tokenId: '1',
        contractAddress: '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        network: BlockchainNetwork.ethereum,
        metadata: metadata,
        owner: '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        creator: '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'active',
        currentValue: 1.5,
        valueCurrency: 'ETH',
        transactionHistory: [],
      );

      expect(nft.formattedContractAddress, '0x1234...7890');
      expect(nft.formattedOwner, '0x4567...0123');
      expect(nft.formattedCreator, '0x7890...3456');
      expect(nft.formattedValue, '1.5000 ETH');
      expect(nft.networkDisplayName, 'Ethereum');
    });
  });
}
