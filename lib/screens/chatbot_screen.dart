import 'dart:io';
import 'dart:typed_data';
import 'package:auto_route/auto_route.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';

@RoutePage()
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final Gemini gemini = Gemini.instance;
  final List<ChatMessage> messages = [];

  final ChatUser currentUser = ChatUser(id: '0', firstName: 'Người dùng');
  final ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: 'Baemin AI',
    profileImage: 'https://cdn-icons-png.flaticon.com/512/4712/4712035.png',
  );

  @override
  void initState() {
    super.initState();
    // Chào mừng ban đầu
    messages.add(
      ChatMessage(
        text:
            'Chào bạn! Tôi là trợ lý AI của Baemin. Hôm nay bạn muốn ăn gì nào? 🍜',
        user: geminiUser,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE0F7FA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Baemin AI',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Đang trực tuyến',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
      ),
      body: DashChat(
        currentUser: currentUser,
        onSend: _sendMessage,
        messages: messages,
        inputOptions: InputOptions(
          leading: [
            IconButton(
              onPressed: _sendMediaMessage,
              icon: const Icon(Icons.image, color: AppColors.primary),
            ),
          ],
          inputDecoration: InputDecoration(
            hintText: 'Nhập tin nhắn...',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF5F6F8),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        messageOptions: const MessageOptions(
          containerColor: AppColors.primary,
          textColor: Colors.white,
          currentUserContainerColor: Colors.white,
          currentUserTextColor: Colors.black87,
        ),
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages.insert(0, chatMessage);
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;

      if (chatMessage.medias != null && chatMessage.medias!.isNotEmpty) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }

      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastMessage = messages.isEmpty ? null : messages.first;

        if (lastMessage != null && lastMessage.user.id == geminiUser.id) {
          String response = event.output ?? "";
          setState(() {
            messages[0] = ChatMessage(
              user: geminiUser,
              createdAt: lastMessage.createdAt,
              text: lastMessage.text + response,
              medias: lastMessage.medias,
            );
          });
        } else {
          String response = event.output ?? "";
          setState(() {
            messages.insert(
              0,
              ChatMessage(
                user: geminiUser,
                createdAt: DateTime.now(),
                text: response,
              ),
            );
          });
        }
      });
    } catch (e) {
      print("Gemini Error: $e");
    }
  }

  void _sendMediaMessage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Hãy phân tích hình ảnh này giúp tôi",
        medias: [
          ChatMedia(
            url: image.path,
            fileName: image.name,
            type: MediaType.image,
          ),
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}
