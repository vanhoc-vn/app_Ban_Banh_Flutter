import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  static const Color _primary = Color(0xFFF23B7E);

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  // Khởi tạo model với API Key của bạn
  late final GenerativeModel _model;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyA6dcgvV13Os5M2zrGwdBto-Tw8FVXVdDQ',
    );
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userMsg = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userMsg});
      _isTyping = true;
    });
    _controller.clear();

    // 1. Lấy dữ liệu thực đơn từ Provider
    // LƯU Ý: Đảm bảo class trong all_products_page.dart đã đổi tên để không trùng với ProductProvider
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final products = productProvider.getAllProductsList;

    // 2. Chuyển danh sách bánh thành văn bản (Sử dụng product_details từ Firestore)
    String productInfo = products.map((p) =>
    "- ${p.name}: Giá \$${p.price}. Chi tiết: ${p.description ?? 'Bánh ngọt Dream Cake'}"
    ).join("\n");

    final prompt = """
      Bạn là chuyên gia dinh dưỡng và trợ lý bán hàng của tiệm bánh 'Dream Cake'. 
      Dưới đây là danh sách bánh chúng tôi có:
      $productInfo
      
      Khách hàng hỏi: "$userMsg"
      
      Yêu cầu:
      1. Gợi ý loại bánh phù hợp từ thực đơn của tiệm.
      2. Phân tích calo, đường, chất béo dựa trên kiến thức của bạn nếu khách hỏi về dinh dưỡng.
      3. Luôn giữ thái độ thân thiện, ngọt ngào.
    """;

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      if (mounted) {
        setState(() {
          _messages.add({"role": "ai", "text": response.text ?? "Tôi chưa hiểu ý bạn, bạn nói lại nhé!"});
        });
      }
    } catch (e) {
      // IN LỖI CHI TIẾT RA CONSOLE ĐỂ KIỂM TRA
      debugPrint("Lỗi Gemini AI: $e");

      if (mounted) {
        setState(() {
          String errorMsg = "Hệ thống AI bận, bạn vui lòng thử lại sau nhé!";
          // Kiểm tra nếu lỗi do vùng địa lý chưa hỗ trợ
          if (e.toString().contains("User location is not supported")) {
            errorMsg = "Lỗi: Vùng của bạn chưa được hỗ trợ. Hãy thử bật VPN sang Mỹ hoặc Singapore.";
          }
          _messages.add({"role": "ai", "text": errorMsg});
        });
      }
    } finally {
      if (mounted) setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FB),
      appBar: AppBar(
        title: const Text("Tư vấn Dream Cake AI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _primary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                bool isUser = _messages[i]['role'] == 'user';
                return _buildChatBubble(isUser, _messages[i]['text']!);
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("AI đang phân tích thực đơn...", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(bool isUser, String text) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? _primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isUser ? 15 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 15),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Text(text, style: TextStyle(color: isUser ? Colors.white : Colors.black87)),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Hỏi AI về dinh dưỡng và bánh...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: _primary),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}