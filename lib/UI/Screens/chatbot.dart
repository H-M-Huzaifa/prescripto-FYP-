import 'dart:convert';
import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../Utilities/colors.dart';
import '../../Utilities/screen_size_config.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final String apiKey = "AIzaSyDvZFko4G-8fv6kJGy36sp_tfCogN2c7Uo"; // Replace with your API key
  final String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDvZFko4G-8fv6kJGy36sp_tfCogN2c7Uo";

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "Gemini",
    profileImage:
    "https://static.vecteezy.com/system/resources/previews/046/861/646/non_2x/gemini-icon-on-a-transparent-background-free-png.png",
  );

  // Memory: Persistent information chatbot should remember
  final List<Map<String, dynamic>> memory = [
    {
      "role": "user",
      "parts": [
        {
          "text": "Remember these things:\n\n"
              "The app name in which I am integrating you is Prescripto.\n"
              "Prescripto is a medical store with modules of NLP-based medical prescription classification to read and extract "
              "information from poorly handwritten prescriptions and a chatbot like you.\n"
              "This is developed by Hafiz Muhammad Huzaifa, Rimsha Mushtaq, and Raheel Mughal. They are final-year students of "
              "Software Engineering at CECOS University."
        }
      ]
    }
  ];

  // Chat history to retain memory of past conversations
  List<Map<String, dynamic>> chatHistory = [];

  @override
  Widget build(BuildContext context) {
    screen_config size=screen_config(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title:  Text("Chat with AI",style: TextStyle( fontFamily: 'Bebas',
            fontSize: size.text*1.2,
            fontWeight: FontWeight.bold,
            color: myColors.primary_color),),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        // trailing: [
        //   IconButton(
        //     onPressed: _sendMediaMessage,
        //     icon: const Icon(Icons.image),
        //   )
        // ],
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  // Function to send text messages
  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages.insert(0, chatMessage);
    });

    String prompt = chatMessage.text;

    // Add user message to chat history
    chatHistory.add({
      "role": "user",
      "parts": [
        {"text": prompt}
      ]
    });

    _getResponseFromAPI().then((response) {
      ChatMessage message = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: response,
      );

      setState(() {
        messages.insert(0, message);
      });

      // Add chatbot response to chat history
      chatHistory.add({
        "role": "model",
        "parts": [
          {"text": response}
        ]
      });
    }).catchError((error) {
      print("Error: $error");
    });
  }

  // Function to call Gemini API with memory & chat history
  Future<String> _getResponseFromAPI() async {
    try {
      // Combine memory and chat history in the request
      final List<Map<String, dynamic>> messagesToSend = [
        ...memory,
        ...chatHistory
      ];

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"contents": messagesToSend}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"]?[0]["content"]["parts"]?[0]["text"] ?? "No response";
      } else {
        print("Error: ${response.body}");
        return "Error fetching response";
      }
    } catch (e) {
      print("Exception: $e");
      return "Error occurred";
    }
  }

  // Function to send images (media messages)
  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image),
        ],
      );

      _sendMessage(chatMessage);
    }
  }
}
