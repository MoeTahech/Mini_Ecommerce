import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/data/product_model.dart';
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
    final lowStock = ref.watch(productsProvider.notifier).lowStock;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: const Text("Admin Home"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(color: Colors.blue[900]),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Enter product name" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descCtrl,
                        decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(color: Colors.blue[900]),
                        ),
                        validator: (v) =>
                            v!.isEmpty ? "Enter description" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: priceCtrl,
                        decoration: InputDecoration(
                          labelText: "Price",
                          labelStyle: TextStyle(color: Colors.blue[900]),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? "Enter price" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: stockCtrl,
                        decoration: InputDecoration(
                          labelText: "Stock",
                          labelStyle: TextStyle(color: Colors.blue[900]),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? "Enter stock" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: imageCtrl,
                        decoration: InputDecoration(
                          labelText: "Image URL",
                          labelStyle: TextStyle(color: Colors.blue[900]),
                        ),
                        validator: (v) => v!.isEmpty ? "Enter image URL" : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
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
                              ref
                                  .read(productsProvider.notifier)
                                  .addProduct(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Product added")),
                              );
                              _formKey.currentState!.reset();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text("Add Product",
                              style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2️⃣ All Orders Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final order = orders[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 4,
                child: ExpansionTile(
                  title: Text("Order #${order.id}",
                      style: TextStyle(color: Colors.blue[900])),
                  subtitle: Text(
                      "Date: ${order.date.toLocal().toString().split(' ')[0]}"),
                  trailing:
                      Text("\$${order.total.toStringAsFixed(2)}", style: TextStyle(color: Colors.blue[700])),
                  children: order.items
                      .map(
                        (item) => ListTile(
                          title: Text(item.product.name),
                          trailing: Text("x${item.quantity}"),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),

          // 3️⃣ Low Stock Tab
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lowStock.length,
            itemBuilder: (context, i) {
              final product = lowStock[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 4,
                child: ListTile(
                  title: Text(product.name, style: TextStyle(color: Colors.blue[900])),
                  subtitle: Text("Stock: ${product.stock}"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
