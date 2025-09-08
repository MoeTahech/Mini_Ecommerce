import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../orders/orders_controller.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  Future<void> _refreshOrders(WidgetRef ref) async {
    ref.invalidate(ordersProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.list_alt, size: 60, color: Colors.grey),
            SizedBox(height: 8),
            Text("No orders yet", style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _refreshOrders(ref),
      child: ListView.builder(
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
