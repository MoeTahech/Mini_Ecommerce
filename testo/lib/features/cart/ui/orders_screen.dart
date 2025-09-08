import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../orders/orders_controller.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: orders.isEmpty
          ? const Center(child: Text("No orders yet"))
          : ListView.builder(
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
    );
  }
}
