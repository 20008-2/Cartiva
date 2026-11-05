import 'package:flutter/material.dart';

void main() => runApp(const CartivaApp());

const ink = Color(0xFF111827);
const gold = Color(0xFFD6A84F);
const cream = Color(0xFFF8F6F1);

class CartivaApp extends StatelessWidget {
  const CartivaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CARTIVA',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: gold),
        appBarTheme: const AppBarTheme(
          backgroundColor: ink,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const StoreHome(),
    );
  }
}

enum ProductType { dropship, affiliate }

class StoreProduct {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final ProductType type;

  const StoreProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.type,
  });
}

const products = <StoreProduct>[
  StoreProduct(
    name: 'Everyday Backpack',
    description: 'A practical bag for work, school and travel.',
    price: 18500,
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=900',
    type: ProductType.dropship,
  ),
  StoreProduct(
    name: 'Classic Wristwatch',
    description: 'A simple, smart accessory for everyday wear.',
    price: 22000,
    imageUrl: 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=900',
    type: ProductType.dropship,
  ),
  StoreProduct(
    name: 'Wireless Headphones',
    description: 'Comfortable headphones for music and calls.',
    price: 30000,
    imageUrl: 'https://images.unsplash.com/photo-150್ಷ?auto=format',
    type: ProductType.affiliate,
  ),
  StoreProduct(
    name: 'Minimal Desk Lamp',
    description: 'A clean-looking lamp for your workspace.',
    price: 16000,
    imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=900',
    type: ProductType.affiliate,
  ),
];

class StoreHome extends StatefulWidget {
  const StoreHome({super.key});

  @override
  State<StoreHome> createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  int tab = 0;
  final Map<StoreProduct, int> cart = {};

  double get total => cart.entries.fold(
      0, (sum, entry) => sum + entry.key.price * entry.value);

  void add(StoreProduct product) {
    if (product.type == ProductType.affiliate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add your approved affiliate URL to this product before publishing.'),
        ),
      );
      return;
    }
    setState(() => cart[product] = (cart[product] ?? 0) + 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to your cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _productList(products.where((p) => p.type == ProductType.dropship).toList(),
          'Shop CARTIVA', 'Products supplied by our partner suppliers.'),
      _cartPage(),
      _productList(products.where((p) => p.type == ProductType.affiliate).toList(),
          'Partner Deals', 'Buy from our affiliate partners using their tracked links.'),
      const AboutPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CARTIVA', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        actions: [
          IconButton(
            tooltip: 'Shopping cart',
            onPressed: () => setState(() => tab = 1),
            icon: Badge(
              label: Text('${cart.values.fold<int>(0, (a, b) => a + b)}'),
              isLabelVisible: cart.isNotEmpty,
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          )
        ],
      ),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront_outlined), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.link), label: 'Partner Deals'),
          NavigationDestination(icon: Icon(Icons.info_outline), label: 'About'),
        ],
      ),
    );
  }

  Widget _productList(List<StoreProduct> items, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ink)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.black54)),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: items.length,
            itemBuilder: (context, index) => ProductCard(
              product: items[index],
              onPressed: () => add(items[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cartPage() {
    if (cart.isEmpty) {
      return const Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(Icons.shopping_bag_outlined, size: 58, color: gold),
          SizedBox(height: 12), Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('Add products from Shop CARTIVA to get started.')],
      ));
    }
    return Column(children: [
      Expanded(child: ListView(
        padding: const EdgeInsets.all(16),
        children: cart.entries.map((entry) => Card(
          child: ListTile(
            title: Text(entry.key.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('₦${entry.key.price.toStringAsFixed(0)}  •  Quantity: ${entry.value}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => setState(() {
                if (entry.value <= 1) { cart.remove(entry.key); }
                else { cart[entry.key] = entry.value - 1; }
              }),
            ),
          ),
        )).toList(),
      )),
      Container(
        padding: const EdgeInsets.all(18),
        color: Colors.white,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Subtotal', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('₦${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
          const Text('Demo checkout: connect a payment provider and order-management system before accepting real payments.',
              style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: ink, padding: const EdgeInsets.all(15)),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Checkout is not connected yet'),
                content: const Text('This starter app does not collect payments or send orders. Add your payment and fulfilment setup before launching.'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
              ),
            ),
            child: const Text('Proceed to checkout'),
          )),
        ]),
      )
    ]);
  }
}

class ProductCard extends StatelessWidget {
  final StoreProduct product;
  final VoidCallback onPressed;
  const ProductCard({super.key, required this.product, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final affiliate = product.type == ProductType.affiliate;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AspectRatio(
          aspectRatio: 16 / 8,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFFE8E2D7),
              child: const Icon(Icons.image_outlined, size: 48, color: Colors.black38),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              Chip(label: Text(affiliate ? 'AFFILIATE' : 'DROPSHIP')),
            ]),
            Text(product.description, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('₦${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ink)),
              FilledButton(
                onPressed: onPressed,
                style: FilledButton.styleFrom(backgroundColor: ink),
                child: Text(affiliate ? 'Partner link' : 'Add to cart'),
              )
            ])
          ]),
        )
      ]),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Welcome to CARTIVA', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: ink)),
      SizedBox(height: 12),
      Text('Your Home of Quality and Long-Lasting Products', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      SizedBox(height: 8),
      Text('Everything You Want, All in One Place.'),
      SizedBox(height: 20),
      Text('CARTIVA brings together products fulfilled through partner suppliers and selected affiliate offers.'),
      SizedBox(height: 12),
      Text('This is an early starter version. Replace sample products, prices and images, add your supplier details and affiliate URLs, and connect secure checkout before accepting orders.',
        style: TextStyle(color: Colors.black54)),
    ]),
  );
}
