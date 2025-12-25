import 'package:e_commerical/screens/login.dart';
import 'package:e_commerical/screens/welcomescreen.dart'; // Để điều hướng khi logout
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
  // Màu sắc chủ đề đồng bộ
  static const Color _primary = Color(0xFFF23B7E);
  static const Color _bg = Color(0xFFFFF6FB);

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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi đăng xuất: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return _buildMobileLayout();
        }
        return _buildDesktopLayout();
      },
    );
  }

  // --- GIAO DIỆN MOBILE ---
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: _primary,
        elevation: 0.5,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: _bg),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('images/dream_cake_2.png', height: 60),
                    const SizedBox(height: 10),
                    const Text('AD DREAM CAKE',
                        style: TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
            ),
            _buildMenuItem(Icons.inventory_2, 'Sản phẩm', 0),
            _buildMenuItem(Icons.shopping_cart, 'Đơn hàng', 1),
            _buildMenuItem(Icons.people, 'Khách hàng', 2),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  // --- GIAO DIỆN DESKTOP (SIDEBAR) ---
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: _bg,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarExpanded ? 260 : 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: _buildSidebarContent(),
          ),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset('images/dream_cake_2.png', height: 50),
        if (_isSidebarExpanded) ...[
          const SizedBox(height: 10),
          const Text("Dream Cake Admin",
              style: TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
        const SizedBox(height: 30),
        _buildMenuItem(Icons.inventory_2, 'Sản phẩm', 0, isSidebar: true),
        _buildMenuItem(Icons.shopping_cart, 'Đơn hàng', 1, isSidebar: true),
        _buildMenuItem(Icons.people, 'Khách hàng', 2, isSidebar: true),
        const Spacer(),
        _buildMenuItem(Icons.logout, 'Đăng xuất', -1, isSidebar: true, isLogout: true),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isSidebarExpanded ? Icons.menu_open : Icons.menu, color: _primary),
            onPressed: () => setState(() => _isSidebarExpanded = !_isSidebarExpanded),
          ),
          const SizedBox(width: 10),
          Text(
            _selectedIndex == 0 ? "Quản lý sản phẩm" : (_selectedIndex == 1 ? "Quản lý đơn hàng" : "Quản lý khách hàng"),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const Spacer(),
          const CircleAvatar(backgroundColor: _bg, child: Icon(Icons.person, color: _primary)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index, {bool isSidebar = false, bool isLogout = false}) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isSelected ? _primary.withOpacity(0.1) : Colors.transparent,
        leading: Icon(icon, color: isLogout ? Colors.red : (isSelected ? _primary : Colors.black54)),
        title: (_isSidebarExpanded || !isSidebar)
            ? Text(title, style: TextStyle(
          color: isLogout ? Colors.red : (isSelected ? _primary : Colors.black87),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ))
            : null,
        onTap: isLogout ? _handleLogout : () {
          setState(() => _selectedIndex = index);
          if (!isSidebar) Navigator.pop(context);
        },
      ),
    );
  }
}