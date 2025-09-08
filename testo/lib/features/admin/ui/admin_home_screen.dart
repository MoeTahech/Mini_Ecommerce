import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/data/product_model.dart';
//import../../home/data/product_repository.dart';
import '../../orders/orders_controller.dart';
import '../data/products_controller.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  final imageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    ref.read(productsProvider.notifier).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Add Product"),
            Tab(text: "All Orders"),
            Tab(text: "Low Stock"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1️⃣ Add Product Tab
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: "Name"),
                    validator: (v) =>
                        v!.isEmpty ? "Enter product name" : null,
                  ),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (v) =>
                        v!.isEmpty ? "Enter description" : null,
                  ),
                  TextFormField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v!.isEmpty ? "Enter price" : null,
                  ),
                  TextFormField(
                    controller: stockCtrl,
                    decoration: const InputDecoration(labelText: "Stock"),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v!.isEmpty ? "Enter stock" : null,
                  ),
                  TextFormField(
                    controller: imageCtrl,
                    decoration: const InputDecoration(labelText: "Image URL"),
                    validator: (v) =>
                        v!.isEmpty ? "Enter image URL" : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final product = Product(
                          id: products.isEmpty ? 1 : products.last.id + 1,
                          name: nameCtrl.text,
                          description: descCtrl.text,
                          price: double.tryParse(priceCtrl.text) ?? 0,
                          stock: int.tryParse(stockCtrl.text) ?? 0,
                          imageUrl: imageCtrl.text,
                        );
                        ref.read(productsProvider.notifier).addProduct(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Product added")),
                        );
                        _formKey.currentState!.reset();
                      }
                    },
                    child: const Text("Add Product"),
                  ),
                ],
              ),
            ),
          ),

          // 2️⃣ All Orders Tab
          ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final order = orders[i];
              return ExpansionTile(
                title: Text("Order #${order.id}"),
                subtitle: Text(
                    "Date: ${order.date.toLocal().toString().split(' ')[0]}"),
                trailing: Text("\$${order.total.toStringAsFixed(2)}"),
                children: order.items
                    .map(
                      (item) => ListTile(
                        title: Text(item.product.name),
                        trailing: Text("x${item.quantity}"),
                      ),
                    )
                    .toList(),
              );
            },
          ),

          // 3️⃣ Low Stock Tab
          ListView.builder(
            itemCount: ref.watch(productsProvider.notifier).lowStock.length,
            itemBuilder: (context, i) {
              final product =
                  ref.watch(productsProvider.notifier).lowStock[i];
              return ListTile(
                title: Text(product.name),
                subtitle: Text("Stock: ${product.stock}"),
              );
            },
          ),
        ],
      ),
    );
  }
}
