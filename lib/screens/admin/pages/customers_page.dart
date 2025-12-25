import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/customer_provider.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  static const Color _primary = Color(0xFFF23B7E); // Hồng Dream Cake
  static const Color _bg = Color(0xFFFFF6FB);

  @override
  void initState() {
    super.initState();
    // Tự động tải dữ liệu khi mở trang
    Future.microtask(() {
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề và nút làm mới
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh sách thành viên',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                IconButton(
                  onPressed: () => Provider.of<CustomerProvider>(context, listen: false).fetchCustomers(),
                  icon: const Icon(Icons.refresh, color: _primary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Danh sách hiển thị
            Expanded(
              child: Consumer<CustomerProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: _primary));
                  }

                  if (provider.customers.isEmpty) {
                    return const Center(
                      child: Text('Không tìm thấy tài khoản nào trong collection "users"'),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.customers.length,
                    itemBuilder: (context, index) {
                      final customer = provider.customers[index];
                      final bool isBlocked = customer['isBlocked'] ?? false;
                      final String role = customer['role'] ?? 'user';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: isBlocked ? Colors.red.withOpacity(0.1) : _primary.withOpacity(0.1),
                            child: Icon(isBlocked ? Icons.block : Icons.person, color: isBlocked ? Colors.red : _primary),
                          ),
                          title: Row(
                            children: [
                              Text(customer['userName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), // userName
                              const SizedBox(width: 8),
                              _buildRoleBadge(role),
                            ],
                          ),
                          subtitle: Text('Email: ${customer['email']}'),
                          trailing: Switch(
                            value: !isBlocked,
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            onChanged: (value) {
                              provider.toggleBlockUser(customer['uid'], isBlocked);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị nhãn Admin/User
  Widget _buildRoleBadge(String role) {
    bool isAdmin = role == 'admin'; //
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isAdmin ? Colors.orange.shade100 : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isAdmin ? Colors.orange.shade900 : Colors.blue.shade900),
      ),
    );
  }
}