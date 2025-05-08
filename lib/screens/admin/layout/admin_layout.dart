import 'package:e_commerical/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/orders_page.dart';
import '../pages/products_page.dart';
import '../pages/customers_page.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;

  final List<Widget> _pages = [
    const ProductsPage(),
    const OrdersPage(),
    const CustomersPage(),
  ];

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi đăng xuất: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Kiểm tra nếu là mobile (width < 600)
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout();
        }
        // Nếu là tablet hoặc desktop
        return _buildDesktopLayout();
      },
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoang Admin'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.deepPurple,
          child: Column(
            children: [
              // Drawer Header
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.deepPurple),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 40,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                          size: 30,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Hoang Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      icon: Icons.inventory_2,
                      title: 'Sản phẩm',
                      index: 0,
                    ),
                    _buildDrawerItem(
                      icon: Icons.shopping_cart,
                      title: 'Đơn hàng',
                      index: 1,
                    ),
                    _buildDrawerItem(
                      icon: Icons.people,
                      title: 'Khách hàng',
                      index: 2,
                    ),
                    const Divider(color: Colors.white24),
                    // ListTile(
                    //   leading: const Icon(Icons.logout, color: Colors.white70),
                    //   title: const Text(
                    //     'Đăng xuất',
                    //     style: TextStyle(color: Colors.white70),
                    //   ),
                    //   onTap: _handleLogout,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.white : Colors.white70),
      ),
      selected: isSelected,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context); // Đóng drawer sau khi chọn
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isSidebarExpanded ? 250 : 70,
            child: _buildSidebar(),
          ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isSidebarExpanded
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                        ),
                        onPressed: () {
                          setState(() {
                            _isSidebarExpanded = !_isSidebarExpanded;
                          });
                        },
                      ),
                      const Spacer(),
                      // Thêm nút đăng xuất vào top bar
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: _handleLogout,
                      ),
                    ],
                  ),
                ),
                // Main content
                Expanded(child: Material(child: _pages[_selectedIndex])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.inventory_2, 'title': 'Sản phẩm', 'index': 0},
      {'icon': Icons.shopping_cart, 'title': 'Đơn hàng', 'index': 1},
      {'icon': Icons.people, 'title': 'Khách hàng', 'index': 2},
    ];

    return Container(
      color: Colors.deepPurple,
      child: Column(
        children: [
          // Logo và tên app
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.shopping_bag,
                      color: Colors.white,
                      size: 30,
                    );
                  },
                ),
                if (_isSidebarExpanded) ...[
                  const SizedBox(width: 10),
                  const Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          // Menu items
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final isSelected = _selectedIndex == item['index'];
                return ListTile(
                  leading: Icon(
                    item['icon'],
                    color: isSelected ? Colors.white : Colors.white70,
                  ),
                  title:
                      _isSidebarExpanded
                          ? Text(
                            item['title'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white70,
                            ),
                          )
                          : null,
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedIndex = item['index'];
                    });
                    // Đóng drawer nếu đang ở mobile
                    if (MediaQuery.of(context).size.width < 600) {
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
