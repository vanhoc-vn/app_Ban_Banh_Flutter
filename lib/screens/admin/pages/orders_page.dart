import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/order_provider.dart';
import '../../../model/order_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // Màu sắc chủ đề Dream Cake
  static const Color _primary = Color(0xFFF23B7E);
  static const Color _bg = Color(0xFFFFF6FB);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
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
            // Header: Tiêu đề và nút làm mới
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Quản lý đơn hàng',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                ElevatedButton.icon(
                  onPressed: () => Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text('Cập nhật'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: _primary));
                  }

                  if (provider.orders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 80, color: _primary.withOpacity(0.3)),
                          const SizedBox(height: 10),
                          const Text('Chưa có đơn hàng nào', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.orders.length,
                    itemBuilder: (context, index) {
                      final order = provider.orders[index];
                      return _buildOrderCard(order, provider);
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

  // --- Widget: Thẻ đơn hàng tùy chỉnh ---
  Widget _buildOrderCard(OrderModel order, OrderProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: _primary,
          collapsedIconColor: Colors.grey,
          title: Text(
            'Đơn hàng: #${order.orderId.substring(order.orderId.length - 6).toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: _buildStatusBadge(order.status),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Text('Chi tiết sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold, color: _primary)),
                  const SizedBox(height: 10),
                  ...order.products.map((product) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.cake_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(child: Text('${product.name} x${product.quantity}')),
                        Text('\$${(product.price * product.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng thanh toán:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('\$${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.location_on_outlined, 'Địa chỉ:', '${order.shippingAddress.street}, ${order.shippingAddress.city}'),
                  const SizedBox(height: 20),

                  // Khu vực cập nhật trạng thái
                  const Text('Cập nhật trạng thái:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _primary.withOpacity(0.2)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: order.status,
                        items: {
                          'pending': 'Đang chờ xác nhận',
                          'processing': 'Đang xử lý',
                          'shipped': 'Đang giao hàng',
                          'delivered': 'Đã giao thành công',
                        }.entries.map((entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        )).toList(),
                        onChanged: (newStatus) {
                          if (newStatus != null) {
                            provider.updateOrderStatus(order.orderId, newStatus);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = _getStatusColor(status);
    String text = _translateStatus(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(width: 4),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: Colors.black54))),
      ],
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'pending': return 'Đang chờ';
      case 'processing': return 'Xử lý';
      case 'shipped': return 'Đang giao';
      case 'delivered': return 'Đã giao';
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'processing': return Colors.blue;
      case 'shipped': return Colors.purple;
      case 'delivered': return Colors.green;
      default: return Colors.grey;
    }
  }
}