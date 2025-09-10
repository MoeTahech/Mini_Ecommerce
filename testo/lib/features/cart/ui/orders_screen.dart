import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../orders/orders_controller.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  Future<void> _refreshOrders(WidgetRef ref) async {
    await ref.read(ordersProvider.notifier).fetchUserOrders();
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    if (orders.isEmpty) {
      return const Center(child: Text("No orders yet"));
    }

    final sortedOrders = [...orders]..sort((a, b) => b.date.compareTo(a.date));

    return RefreshIndicator(
      onRefresh: () => _refreshOrders(ref),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sortedOrders.length,
        itemBuilder: (context, i) {
          final order = sortedOrders[i];

          // Example: fake status if your backend doesn't have it yet
          final status = i % 2 == 0 ? "Completed" : "Pending";

          return Card(
            color: order.total > 500 ? Colors.green[50] : Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 4,
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order #${order.id}"),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                  "Date: ${order.date.toLocal().toString().split(' ')[0]}"),
              trailing: Text("\$${order.total.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.blue)),
              children: order.items
                  .map(
                    (item) => ListTile(
                      title: Text(item.product.name),
                      subtitle: Text("Quantity: ${item.quantity}"),
                      trailing:
                          Text("\$${item.totalPrice.toStringAsFixed(2)}"),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
