import 'package:flutter/material.dart';
import '../../home/ui/catalog_screen.dart';
import '../../cart/ui/cart_screen.dart';
import '../../cart/ui/orders_screen.dart';
import '../../../core/session.dart';
import '../../auth/ui/login_screen.dart';
import '../../admin/ui/admin_home_screen.dart';
import '../../../core/api_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late ApiClient api;
  List<Widget>? _pages; // make nullable

  @override
  void initState() {
    super.initState();
    api = ApiClient("http://localhost:8080");
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await Session.getToken();
    if (token != null) {
      api.setToken(token);
    }

    // Initialize pages after token is set
    setState(() {
      _pages = [
        CatalogScreen(api: api),
        const CartScreen(),
        const OrdersScreen(),
      ];
    });
  }

  void _logout() async {
    try {
      await Session.clearToken();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logout failed, please try again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Mini Ecommerce"),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
              );
            },
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            label: const Text("Admin", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _pages == null
          ? const Center(child: CircularProgressIndicator())
          : _pages!.isEmpty
              ? const Center(child: Text("No pages loaded"))
              : _pages![_selectedIndex], // safe access
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Orders"),
        ],
      ),
    );
  }
}
