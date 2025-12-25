import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order_provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  static const Color _primary = Color(0xFFF23B7E);
  static const Color _bg = Color(0xFFFFF6FB);

  @override
  void initState() {
    super.initState();
    // Gọi hàm lấy đơn hàng ngay khi khởi tạo màn hình
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).fetchMyOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe sự thay đổi từ OrderProvider
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: _bg,
      // SỬA LỖI TẠI ĐÂY: app_bar -> appBar
      appBar: AppBar(
        title: const Text(
          "Đơn hàng của tôi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : orderProvider.myOrders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: orderProvider.myOrders.length,
        itemBuilder: (ctx, index) {
          final order = orderProvider.myOrders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 80, color: _primary.withOpacity(0.3)),
          const SizedBox(height: 10),
          const Text("Bạn chưa có đơn hàng nào!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(dynamic order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        // Lấy 6 ký tự cuối của OrderId để hiển thị mã đơn hàng ngắn gọn
        title: Text(
          "Mã đơn: #${order.orderId.substring(order.orderId.length - 6).toUpperCase()}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: _buildStatusBadge(order.status),
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sản phẩm đã mua:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: _primary),
                ),
                const SizedBox(height: 10),
                ...order.products.map<Widget>((p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${p.name} x${p.quantity}"),
                      Text("\$${(p.price * p.quantity).toStringAsFixed(2)}"),
                    ],
                  ),
                )).toList(),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tổng cộng:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      "\$${order.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(color: _primary, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Địa chỉ: ${order.shippingAddress.street}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Map<String, dynamic> statusMap = {
      'pending': {'text': 'Đang chờ', 'color': Colors.orange},
      'processing': {'text': 'Đang làm bánh', 'color': Colors.blue},
      'shipped': {'text': 'Đang giao', 'color': Colors.purple},
      'delivered': {'text': 'Đã nhận bánh', 'color': Colors.green},
    };
    var current = statusMap[status] ?? {'text': status, 'color': Colors.grey};

    return Container(
      margin: const EdgeInsets.only(top: 5),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: current['color'].withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          current['text'],
          style: TextStyle(color: current['color'], fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}