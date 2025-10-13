import 'package:flutter/material.dart';
import 'package:flutter_yuku/flutter_yuku.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Yuku Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final YukuClient _client = YukuClient();
  late TabController _tabController;
  bool _isInitialized = false;
  String _status = 'Not initialized';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeClient();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeClient() async {
    try {
      // Configure networks
      _client.setNetworkConfig(
        BlockchainNetwork.ethereum,
        const NetworkConfig(
          name: 'Ethereum Mainnet',
          rpcUrl: 'https://mainnet.infura.io/v3/YOUR_KEY',
          chainId: '1',
          network: BlockchainNetwork.ethereum,
          isTestnet: false,
        ),
      );

      _client.setNetworkConfig(
        BlockchainNetwork.solana,
        const NetworkConfig(
          name: 'Solana Mainnet',
          rpcUrl: 'https://api.mainnet-beta.solana.com',
          chainId: 'mainnet-beta',
          network: BlockchainNetwork.solana,
          isTestnet: false,
        ),
      );

      _client.setNetworkConfig(
        BlockchainNetwork.polygon,
        const NetworkConfig(
          name: 'Polygon Mainnet',
          rpcUrl: 'https://polygon-rpc.com',
          chainId: '137',
          network: BlockchainNetwork.polygon,
          isTestnet: false,
        ),
      );

      _client.setNetworkConfig(
        BlockchainNetwork.icp,
        const NetworkConfig(
          name: 'ICP Mainnet',
          rpcUrl: 'https://ic0.app',
          chainId: 'icp',
          network: BlockchainNetwork.icp,
          isTestnet: false,
        ),
      );

      await _client.initialize();
      setState(() {
        _isInitialized = true;
        _status = 'Initialized successfully';
      });
    } catch (e) {
      setState(() {
        _status = 'Initialization failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Yuku Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Client'),
            Tab(icon: Icon(Icons.account_balance_wallet), text: 'Wallet'),
            Tab(icon: Icon(Icons.image), text: 'NFT'),
            Tab(icon: Icon(Icons.store), text: 'Marketplace'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ClientInfoTab(
            client: _client,
            isInitialized: _isInitialized,
            status: _status,
          ),
          WalletTab(client: _client, isInitialized: _isInitialized),
          NFTTab(client: _client, isInitialized: _isInitialized),
          MarketplaceTab(client: _client, isInitialized: _isInitialized),
        ],
      ),
    );
  }
}

// Client Info & Utils Tab
class ClientInfoTab extends StatelessWidget {
  final YukuClient client;
  final bool isInitialized;
  final String status;

  const ClientInfoTab({
    super.key,
    required this.client,
    required this.isInitialized,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('Status', [
            _buildInfoRow('Client Status', status),
            _buildInfoRow('Initialized', isInitialized.toString()),
          ]),
          const SizedBox(height: 20),
          if (isInitialized) ...[
            _buildSection('Client Information', [
              _buildInfoRow('Version', client.getClientInfo()['version']),
              _buildInfoRow(
                'Supported Networks',
                client.getSupportedNetworks().map((e) => e.name).join(', '),
              ),
              _buildInfoRow(
                'Provider Stats',
                client.getProviderStats().toString(),
              ),
            ]),
            const SizedBox(height: 20),
            _buildSection(
              'Supported Networks',
              client.getSupportedNetworks().map((network) {
                return _buildInfoRow(
                  YukuUtils.getNetworkDisplayName(network),
                  network.name,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showUtilsDialog(context),
              icon: const Icon(Icons.build),
              label: const Text('Show Utils Examples'),
            ),
          ],
        ],
      ),
    );
  }

  void _showUtilsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Utils Examples'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Address Validation:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Ethereum: ${YukuUtils.isValidEthereumAddress("0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a")}',
              ),
              Text(
                'Solana: ${YukuUtils.isValidSolanaAddress("9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM")}',
              ),
              Text(
                'ICP: ${YukuUtils.isValidICPPrincipal("rdmx6-jaaaa-aaaaa-aaadq-cai")}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Price Formatting:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text('ETH: ${YukuUtils.formatPrice(1.5, "ETH")}'),
              Text('SOL: ${YukuUtils.formatPrice(100.0, "SOL")}'),
              Text('ICP: ${YukuUtils.formatPrice(10.0, "ICP")}'),
              const SizedBox(height: 16),
              const Text(
                'Address Formatting:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Short: ${YukuUtils.formatAddress("0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a")}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// Wallet Operations Tab
class WalletTab extends StatefulWidget {
  final YukuClient client;
  final bool isInitialized;

  const WalletTab({
    super.key,
    required this.client,
    required this.isInitialized,
  });

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _toAddressController = TextEditingController();
  String _result = '';
  BlockchainNetwork _selectedNetwork = BlockchainNetwork.ethereum;

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    _toAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isInitialized) {
      return const Center(child: Text('Client not initialized'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wallet Operations',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  DropdownButton<BlockchainNetwork>(
                    value: _selectedNetwork,
                    isExpanded: true,
                    items: widget.client.getSupportedNetworks().map((network) {
                      return DropdownMenuItem(
                        value: network,
                        child: Text(YukuUtils.getNetworkDisplayName(network)),
                      );
                    }).toList(),
                    onChanged: (network) {
                      if (network != null) {
                        setState(() => _selectedNetwork = network);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Wallet Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _validateAddress,
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Validate Address'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _checkBalance,
                    icon: const Icon(Icons.account_balance),
                    label: const Text('Check Balance (Demo)'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Send Transaction (Demo)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  TextField(
                    controller: _toAddressController,
                    decoration: const InputDecoration(
                      labelText: 'To Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _sendTransaction,
                    icon: const Icon(Icons.send),
                    label: const Text('Send Transaction'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_result.isNotEmpty)
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Result:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(_result),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _validateAddress() {
    final address = _addressController.text;
    bool isValid = false;

    switch (_selectedNetwork) {
      case BlockchainNetwork.ethereum:
      case BlockchainNetwork.polygon:
      case BlockchainNetwork.bsc:
        isValid = YukuUtils.isValidEthereumAddress(address);
        break;
      case BlockchainNetwork.solana:
        isValid = YukuUtils.isValidSolanaAddress(address);
        break;
      case BlockchainNetwork.icp:
        isValid = YukuUtils.isValidICPPrincipal(address);
        break;
      default:
        isValid = address.isNotEmpty;
    }

    setState(() {
      _result = 'Address validation: ${isValid ? "✓ Valid" : "✗ Invalid"}';
    });
  }

  void _checkBalance() {
    final address = _addressController.text;
    if (address.isEmpty) {
      setState(() => _result = 'Please enter an address');
      return;
    }

    // Demo balance
    final demoBalance = (100 + address.length % 50).toDouble();
    final currency = _getCurrencySymbol();

    setState(() {
      _result = 'Balance: ${YukuUtils.formatPrice(demoBalance, currency)}';
    });
  }

  void _sendTransaction() {
    final to = _toAddressController.text;
    final amount = double.tryParse(_amountController.text) ?? 0;

    if (to.isEmpty || amount <= 0) {
      setState(() => _result = 'Please enter valid recipient and amount');
      return;
    }

    final currency = _getCurrencySymbol();
    final txHash = 'tx_${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      _result =
          'Transaction sent!\n'
          'To: ${YukuUtils.formatAddress(to)}\n'
          'Amount: ${YukuUtils.formatPrice(amount, currency)}\n'
          'Hash: $txHash';
    });
  }

  String _getCurrencySymbol() {
    switch (_selectedNetwork) {
      case BlockchainNetwork.ethereum:
        return 'ETH';
      case BlockchainNetwork.solana:
        return 'SOL';
      case BlockchainNetwork.polygon:
        return 'MATIC';
      case BlockchainNetwork.bsc:
        return 'BNB';
      case BlockchainNetwork.icp:
        return 'ICP';
      default:
        return 'TOKEN';
    }
  }
}

// NFT Operations Tab
class NFTTab extends StatefulWidget {
  final YukuClient client;
  final bool isInitialized;

  const NFTTab({super.key, required this.client, required this.isInitialized});

  @override
  State<NFTTab> createState() => _NFTTabState();
}

class _NFTTabState extends State<NFTTab> {
  final List<NFT> _demoNFTs = [];

  @override
  void initState() {
    super.initState();
    _generateDemoNFTs();
  }

  void _generateDemoNFTs() {
    _demoNFTs.addAll([
      NFT(
        id: 'nft_1',
        tokenId: '1',
        contractAddress: '0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D',
        network: BlockchainNetwork.ethereum,
        metadata: const NFTMetadata(
          name: 'Bored Ape #1234',
          description: 'A unique Bored Ape NFT',
          image: 'https://example.com/ape.png',
          attributes: {'Rarity': 'Rare', 'Background': 'Blue'},
          properties: {},
          externalUrl: 'https://example.com',
        ),
        owner: '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        creator: '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        status: 'active',
        currentValue: 2.5,
        valueCurrency: 'ETH',
        transactionHistory: const ['tx1', 'tx2'],
      ),
      NFT(
        id: 'nft_2',
        tokenId: '42',
        contractAddress: 'DRiP2Pn2K6fuMLKQmt5rZWspbA485azs9kV75r3kTTZh',
        network: BlockchainNetwork.solana,
        metadata: const NFTMetadata(
          name: 'Solana Monkey #42',
          description: 'A cool Solana Monkey',
          image: 'https://example.com/monkey.png',
          attributes: {'Rarity': 'Epic', 'Type': 'Legendary'},
          properties: {},
          externalUrl: 'https://example.com',
        ),
        owner: '9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM',
        creator: '9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
        status: 'active',
        currentValue: 150.0,
        valueCurrency: 'SOL',
        transactionHistory: const ['tx3'],
      ),
      NFT(
        id: 'nft_3',
        tokenId: '7',
        contractAddress: 'rdmx6-jaaaa-aaaaa-aaadq-cai',
        network: BlockchainNetwork.icp,
        metadata: const NFTMetadata(
          name: 'ICP Punk #7',
          description: 'A punk on Internet Computer',
          image: 'https://example.com/punk.png',
          attributes: {'Rarity': 'Legendary', 'Eyes': 'Laser'},
          properties: {},
          externalUrl: 'https://example.com',
        ),
        owner: 'rdmx6-jaaaa-aaaaa-aaadq-cai',
        creator: 'rdmx6-jaaaa-aaaaa-aaadq-cai',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now(),
        status: 'active',
        currentValue: 50.0,
        valueCurrency: 'ICP',
        transactionHistory: const ['tx4', 'tx5', 'tx6'],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isInitialized) {
      return const Center(child: Text('Client not initialized'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Demo NFT Collection (${_demoNFTs.length} items)',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _demoNFTs.length,
            itemBuilder: (context, index) {
              final nft = _demoNFTs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getNetworkColor(nft.network),
                    child: Text(
                      nft.tokenId,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    nft.metadata.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nft.metadata.description),
                      const SizedBox(height: 4),
                      Text(
                        'Network: ${nft.networkDisplayName}',
                        style: TextStyle(color: _getNetworkColor(nft.network)),
                      ),
                      Text('Owner: ${nft.formattedOwner}'),
                      Text('Value: ${nft.formattedValue}'),
                      Text('Rarity: ${nft.rarity.name}'),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () => _showNFTDetails(nft),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getNetworkColor(BlockchainNetwork network) {
    switch (network) {
      case BlockchainNetwork.ethereum:
        return Colors.blue;
      case BlockchainNetwork.solana:
        return Colors.purple;
      case BlockchainNetwork.polygon:
        return Colors.deepPurple;
      case BlockchainNetwork.bsc:
        return Colors.orange;
      case BlockchainNetwork.icp:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _showNFTDetails(NFT nft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(nft.metadata.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Token ID', nft.tokenId),
              _buildDetailRow('Contract', nft.formattedContractAddress),
              _buildDetailRow('Network', nft.networkDisplayName),
              _buildDetailRow('Owner', nft.formattedOwner),
              _buildDetailRow('Creator', nft.formattedCreator),
              _buildDetailRow('Value', nft.formattedValue),
              _buildDetailRow('Rarity', nft.rarity.name),
              _buildDetailRow('Status', nft.status),
              _buildDetailRow(
                'Created',
                DateFormat('yyyy-MM-dd HH:mm').format(nft.createdAt),
              ),
              _buildDetailRow('Transferable', nft.isTransferable.toString()),
              const SizedBox(height: 8),
              const Text(
                'Attributes:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...nft.metadata.attributes.entries.map(
                (e) => Text('  ${e.key}: ${e.value}'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// Marketplace Operations Tab
class MarketplaceTab extends StatefulWidget {
  final YukuClient client;
  final bool isInitialized;

  const MarketplaceTab({
    super.key,
    required this.client,
    required this.isInitialized,
  });

  @override
  State<MarketplaceTab> createState() => _MarketplaceTabState();
}

class _MarketplaceTabState extends State<MarketplaceTab> {
  final List<NFTListing> _demoListings = [];
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateDemoListings();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _generateDemoListings() {
    _demoListings.addAll([
      NFTListing(
        id: 'listing_1',
        nftId: 'nft_1',
        contractAddress: '0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D',
        network: BlockchainNetwork.ethereum,
        price: 2.5,
        currency: 'ETH',
        sellerAddress: '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        status: ListingStatus.active,
        marketplaceProvider: 'opensea',
      ),
      NFTListing(
        id: 'listing_2',
        nftId: 'nft_2',
        contractAddress: 'DRiP2Pn2K6fuMLKQmt5rZWspbA485azs9kV75r3kTTZh',
        network: BlockchainNetwork.solana,
        price: 150.0,
        currency: 'SOL',
        sellerAddress: '9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        expiresAt: DateTime.now().add(const Duration(days: 3)),
        status: ListingStatus.active,
        marketplaceProvider: 'magiceden',
      ),
      NFTListing(
        id: 'listing_3',
        nftId: 'nft_3',
        contractAddress: 'rdmx6-jaaaa-aaaaa-aaadq-cai',
        network: BlockchainNetwork.icp,
        price: 50.0,
        currency: 'ICP',
        sellerAddress: 'rdmx6-jaaaa-aaaaa-aaadq-cai',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: ListingStatus.sold,
        buyerAddress: 'buyer-principal-id',
        soldAt: DateTime.now().subtract(const Duration(hours: 2)),
        marketplaceProvider: 'yuku',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isInitialized) {
      return const Center(child: Text('Client not initialized'));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Marketplace Listings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: _showCreateListingDialog,
                tooltip: 'Create Listing',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _demoListings.length,
            itemBuilder: (context, index) {
              final listing = _demoListings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(listing.status),
                    child: Icon(
                      _getStatusIcon(listing.status),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    listing.formattedPrice,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NFT ID: ${listing.nftId}'),
                      Text('Network: ${_getNetworkName(listing.network)}'),
                      Text(
                        'Seller: ${YukuUtils.formatAddress(listing.sellerAddress)}',
                      ),
                      Text('Status: ${listing.status.name}'),
                      if (listing.expiresAt != null)
                        Text(
                          'Expires: ${DateFormat('yyyy-MM-dd HH:mm').format(listing.expiresAt!)}',
                        ),
                      if (listing.soldAt != null)
                        Text(
                          'Sold: ${DateFormat('yyyy-MM-dd HH:mm').format(listing.soldAt!)}',
                        ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: listing.isActive
                      ? IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () => _buyNFT(listing),
                        )
                      : null,
                  onTap: () => _showListingDetails(listing),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ListingStatus status) {
    switch (status) {
      case ListingStatus.active:
        return Colors.green;
      case ListingStatus.sold:
        return Colors.blue;
      case ListingStatus.cancelled:
        return Colors.red;
      case ListingStatus.expired:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(ListingStatus status) {
    switch (status) {
      case ListingStatus.active:
        return Icons.store;
      case ListingStatus.sold:
        return Icons.check_circle;
      case ListingStatus.cancelled:
        return Icons.cancel;
      case ListingStatus.expired:
        return Icons.timer_off;
    }
  }

  String _getNetworkName(BlockchainNetwork network) {
    return YukuUtils.getNetworkDisplayName(network);
  }

  void _showCreateListingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Listing (Demo)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('Select NFT and network in production'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _createListing();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _createListing() {
    final price = double.tryParse(_priceController.text) ?? 1.0;
    final newListing = NFTListing(
      id: 'listing_${DateTime.now().millisecondsSinceEpoch}',
      nftId: 'nft_new',
      contractAddress: '0x' + '0' * 40,
      network: BlockchainNetwork.ethereum,
      price: price,
      currency: 'ETH',
      sellerAddress: '0xffcba0b4980eb2d2336bfdb1e5a0fc49c620908a',
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      status: ListingStatus.active,
      marketplaceProvider: 'demo',
    );

    setState(() {
      _demoListings.insert(0, newListing);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Listing created successfully!')),
    );
  }

  void _buyNFT(NFTListing listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buy NFT'),
        content: Text(
          'Purchase this NFT for ${listing.formattedPrice}?\n\n'
          'This is a demo action.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                final index = _demoListings.indexOf(listing);
                _demoListings[index] = listing.copyWith(
                  status: ListingStatus.sold,
                  buyerAddress: '0xBUYER',
                  soldAt: DateTime.now(),
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('NFT purchased successfully!')),
              );
            },
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }

  void _showListingDetails(NFTListing listing) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Listing Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', listing.id),
              _buildDetailRow('NFT ID', listing.nftId),
              _buildDetailRow('Price', listing.formattedPrice),
              _buildDetailRow('Network', _getNetworkName(listing.network)),
              _buildDetailRow(
                'Seller',
                YukuUtils.formatAddress(listing.sellerAddress),
              ),
              _buildDetailRow('Status', listing.status.name),
              _buildDetailRow('Marketplace', listing.marketplaceProvider),
              _buildDetailRow(
                'Created',
                DateFormat('yyyy-MM-dd HH:mm').format(listing.createdAt),
              ),
              if (listing.expiresAt != null)
                _buildDetailRow(
                  'Expires',
                  DateFormat('yyyy-MM-dd HH:mm').format(listing.expiresAt!),
                ),
              if (listing.buyerAddress != null)
                _buildDetailRow(
                  'Buyer',
                  YukuUtils.formatAddress(listing.buyerAddress!),
                ),
              if (listing.soldAt != null)
                _buildDetailRow(
                  'Sold At',
                  DateFormat('yyyy-MM-dd HH:mm').format(listing.soldAt!),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
