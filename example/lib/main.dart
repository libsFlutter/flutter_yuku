import 'package:flutter/material.dart';
import 'package:flutter_yuku/flutter_yuku.dart';

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
      home: const MyHomePage(title: 'Flutter Yuku Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final YukuClient _client = YukuClient();
  bool _isInitialized = false;
  String _status = 'Not initialized';

  @override
  void initState() {
    super.initState();
    _initializeClient();
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Flutter Yuku Example',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Status: $_status', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            if (_isInitialized) ...[
              const Text(
                'Client Information:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FutureBuilder<Map<String, dynamic>>(
                future: Future.value(_client.getClientInfo()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final info = snapshot.data!;
                    return Column(
                      children: [
                        Text('Version: ${info['version']}'),
                        Text('Initialized: ${info['isInitialized']}'),
                        Text(
                          'Supported Networks: ${info['supportedNetworks'].join(', ')}',
                        ),
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Supported Networks:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._client.getSupportedNetworks().map(
                (network) => Text(
                  '- ${YukuUtils.getNetworkDisplayName(network)} (${network.name})',
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isInitialized ? _showUtilsExample : null,
              child: const Text('Show Utils Example'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUtilsExample() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Utils Example'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Address Validation:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Ethereum: ${YukuUtils.isValidEthereumAddress("0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6")}',
              ),
              Text(
                'Solana: ${YukuUtils.isValidSolanaAddress("9WzDXwBbmkg8ZTbNMqUxvQRAyrZzDsGYdLVL9zYtAWWM")}',
              ),
              Text(
                'ICP: ${YukuUtils.isValidICPPrincipal("rdmx6-jaaaa-aaaaa-aaadq-cai")}',
              ),
              const SizedBox(height: 10),
              const Text(
                'Price Formatting:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('ETH: ${YukuUtils.formatPrice(1.5, "ETH")}'),
              Text('SOL: ${YukuUtils.formatPrice(100.0, "SOL")}'),
              Text('ICP: ${YukuUtils.formatPrice(10.0, "ICP")}'),
              const SizedBox(height: 10),
              const Text(
                'Network Info:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Ethereum: ${YukuUtils.getNetworkDisplayName(BlockchainNetwork.ethereum)}',
              ),
              Text(
                'Solana: ${YukuUtils.getNetworkDisplayName(BlockchainNetwork.solana)}',
              ),
              Text(
                'ICP: ${YukuUtils.getNetworkDisplayName(BlockchainNetwork.icp)}',
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
}
