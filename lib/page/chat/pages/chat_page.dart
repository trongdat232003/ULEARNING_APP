import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Để sử dụng DateFormat
import 'package:ulearning_app/common/service/chatService.dart';
import 'package:ulearning_app/page/chat/bloc/chat_blocs.dart';
import 'package:ulearning_app/page/chat/bloc/chat_events.dart';
import 'package:ulearning_app/page/chat/bloc/chat_states.dart';

class ChatPage extends StatefulWidget {
  final String senderId; // ID người gửi
  final String receiverId; // ID người nhận

  ChatPage({required this.senderId, required this.receiverId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController =
      TextEditingController(); // Controller cho ô nhập tin nhắn
  final ChatService _chatService = ChatService(); // Dịch vụ chat
  List<Map<String, dynamic>> messages = []; // Danh sách tin nhắn

  @override
  void initState() {
    super.initState();
    _chatService.initSocket(widget.senderId); // Khởi tạo kết nối WebSocket
    _chatService.onMessageReceived((message) {
      print("Message received: $message");
      print("Timestamp received: ${message['timestamp']}");

      if (mounted) {
        setState(() {
          messages.add(message); // Thêm tin nhắn vào danh sách khi nhận được
        });
      }
    });
    fetchMessages(); // Lấy tin nhắn cũ khi mở trang
  }

  void fetchMessages() async {
    print("Đang gọi hàm fetchMessages...");

    final fetchedMessages = await _chatService.fetchMessages(
        widget.senderId, widget.receiverId); // Lấy tin nhắn từ API

    print("Dữ liệu tin nhắn nhận được: $fetchedMessages");

    setState(() {
      messages = List<Map<String, dynamic>>.from(
          fetchedMessages); // Cập nhật lại danh sách tin nhắn
    });
  }

  @override
  void dispose() {
    _chatService.disconnect(); // Ngắt kết nối khi thoát màn hình
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Chat with ${widget.receiverId}")), // Tiêu đề AppBar
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length, // Số lượng tin nhắn
              itemBuilder: (context, index) {
                final message =
                    messages[index]; // Lấy tin nhắn tại vị trí index
                return ListTile(
                  title: Text(message['content']), // Hiển thị nội dung tin nhắn
                  subtitle: Text(
                    message['timestamp'] != null
                        ? DateFormat('dd/MM/yyyy HH:mm') // Định dạng thời gian
                            .format(DateTime.parse(message['timestamp']))
                        : "Không có thời gian", // Nếu không có thời gian thì hiển thị thông báo
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController, // Controller cho ô nhập
                    decoration: InputDecoration(
                        labelText: "Enter message"), // Đặt nhãn cho ô nhập
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send), // Biểu tượng gửi tin nhắn
                  onPressed: () async {
                    final text =
                        _messageController.text.trim(); // Lấy nội dung tin nhắn
                    if (text.isEmpty)
                      return; // Nếu tin nhắn rỗng thì không làm gì

                    // Gửi tin nhắn qua API
                    await _chatService.sendMessageAPI(
                        widget.senderId, widget.receiverId, text);

                    // Gửi tin nhắn qua WebSocket để cập nhật UI real-time
                    _chatService.sendMessage(
                        widget.senderId, widget.receiverId, text);

                    // Hiển thị tin nhắn trên UI của người gửi ngay lập tức
                    setState(() {
                      messages.add({
                        'content': text,
                        'timestamp': DateTime.now()
                            .toString(), // Lưu thời gian gửi tin nhắn
                        'senderId': widget.senderId,
                      });
                    });

                    _messageController.clear(); // Xóa nội dung ô nhập
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
