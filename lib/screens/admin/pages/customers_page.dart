import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/customer_provider.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quản lý người dùng',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Provider.of<CustomerProvider>(
                    context,
                    listen: false,
                  ).fetchCustomers();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Làm mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<CustomerProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.customers.isEmpty) {
                  return const Center(child: Text('Chưa có người dùng nào'));
                }

                return ListView.builder(
                  itemCount: provider.customers.length,
                  itemBuilder: (context, index) {
                    final customer = provider.customers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              customer['isBlocked'] ? Colors.red : Colors.green,
                          child: Icon(
                            customer['isBlocked'] ? Icons.block : Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          customer['userName'] ?? 'Không có tên',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${customer['email']}'),
                            Text('SĐT: ${customer['phone']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: !customer['isBlocked'],
                              onChanged: (value) {
                                _showBlockConfirmation(
                                  context,
                                  customer['uid'],
                                  customer['isBlocked'],
                                  customer['userName'],
                                );
                              },
                              activeColor: Colors.green,
                              inactiveTrackColor: Colors.red,
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                _showCustomerDetails(context, customer);
                              },
                            ),
                          ],
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
    );
  }

  void _showBlockConfirmation(
    BuildContext context,
    String uid,
    bool isBlocked,
    String userName,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isBlocked ? 'Bỏ chặn người dùng' : 'Chặn người dùng'),
            content: Text(
              isBlocked
                  ? 'Bạn có chắc chắn muốn bỏ chặn người dùng "$userName"?'
                  : 'Bạn có chắc chắn muốn chặn người dùng "$userName"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  Provider.of<CustomerProvider>(
                    context,
                    listen: false,
                  ).toggleBlockUser(uid, isBlocked);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isBlocked
                            ? 'Đã bỏ chặn người dùng'
                            : 'Đã chặn người dùng',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBlocked ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(isBlocked ? 'Bỏ chặn' : 'Chặn'),
              ),
            ],
          ),
    );
  }

  void _showCustomerDetails(
    BuildContext context,
    Map<String, dynamic> customer,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Chi tiết người dùng'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên: ${customer['userName']}'),
                const SizedBox(height: 8),
                Text('Email: ${customer['email']}'),
                const SizedBox(height: 8),
                Text('SĐT: ${customer['phone']}'),
                const SizedBox(height: 8),
                Text(
                  'Trạng thái: ${customer['isBlocked'] ? 'Đã chặn' : 'Hoạt động'}',
                  style: TextStyle(
                    color: customer['isBlocked'] ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }
}
