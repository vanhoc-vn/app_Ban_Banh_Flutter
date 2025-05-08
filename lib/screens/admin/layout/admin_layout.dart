import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/dashboard_page.dart';
import '../pages/orders_page.dart';
import '../pages/products_page.dart';
import '../pages/customers_page.dart';
import '../pages/promotions_page.dart';
import '../pages/settings_page.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  final List<_MenuItem> _menuItems = [
    _MenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
      page: const DashboardPage(),
    ),
    _MenuItem(
      title: 'Orders',
      icon: Icons.shopping_cart,
      page: const OrdersPage(),
    ),
    _MenuItem(title: 'Products', icon: Icons.cake, page: const ProductsPage()),
    _MenuItem(
      title: 'Customers',
      icon: Icons.people,
      page: const CustomersPage(),
    ),
    _MenuItem(
      title: 'Promotions',
      icon: Icons.local_offer,
      page: const PromotionsPage(),
    ),
    _MenuItem(
      title: 'Settings',
      icon: Icons.settings,
      page: const SettingsPage(),
    ),
  ];

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng xuất: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 250,
            color: Colors.deepPurple,
            child: Column(
              children: [
                // Admin Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: ClipOval(
                          child: Image.asset(
                            "images/ava.jpg",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Admin Panel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24),
                // Menu Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      final item = _menuItems[index];
                      final isSelected = _selectedIndex == index;
                      return ListTile(
                        leading: Icon(
                          item.icon,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedTileColor: Colors.white.withOpacity(0.1),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white70),
                    title: const Text(
                      'Đăng xuất',
                      style: TextStyle(color: Colors.white70),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Xác nhận đăng xuất'),
                              content: const Text(
                                'Bạn có chắc chắn muốn đăng xuất?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Hủy'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _handleLogout();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: _menuItems[_selectedIndex].page,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final Widget page;

  _MenuItem({required this.title, required this.icon, required this.page});
}
