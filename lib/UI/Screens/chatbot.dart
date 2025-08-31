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
  // SECURITY: Move this to environment variables or secure storage
  final String apiKey = "AIzaSyCiUkIC1fG3NK4iiqHt87Ce5dh1JIsUdOY"; // Replace with your actual API key

  // Try these models in order if one doesn't work:
  // Option 1: gemini-1.5-flash (fastest)
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  // Option 2: gemini-1.5-pro (more capable)
  // final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent";

  // Option 3: gemini-1.0-pro (original, most compatible)
  // final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent";

  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "AI Bot",
    profileImage:
    "assets/icons/chat.png",
  );

  // System prompt for consistent behavior
  final String systemPrompt = """
You are a medical assistant chatbot integrated into the Prescripto mobile application.

IMPORTANT CONTEXT:
- App Name: Prescripto
- App Purpose: Medical store application with NLP-based prescription classification
- App Features: Reads and extracts information from handwritten prescriptions + AI chatbot (you)
- Developers: Hafiz Muhammad Huzaifa, Rimsha Mushtaq UI/UX Designer, and Raheel Mughal AI Developer
- Developers' Status: Final-year Software Engineering students at CECOS University

YOUR ROLE:
- You are the AI chatbot component of Prescripto
- Provide helpful medical information and assistance
- Help users understand prescriptions and medical terminology
- Be professional, accurate, and helpful
- Always mention you're part of the Prescripto app when relevant

AVAILABLE MEDICINES IN PRESCRIPTO DATABASE:
You have access to information about these medicines available in the Prescripto medical store:

1. Ansid (Diazepam) - 1 Strip - Rs. 70 - For anxiety management
2. Amoxil (Amoxicillin) - 1 Strip - Rs. 150 - Antibiotic for bacterial infections
3. Avil (Pheniramine) - 1 Strip - Rs. 60 - For allergy symptoms
4. Brexin (Piroxicam) - 1 Strip - Rs. 110 - For pain and inflammation (arthritis)
5. Calamox (Amoxicillin + Clavulanic Acid) - 1 Pack - Rs. 280 - Broad-spectrum antibiotic
6. Caloned (Calcium Carbonate) - 1 Bottle - Rs. 120 - Calcium supplement for bones
7. Capoten (Captopril) - 1 Strip - Rs. 200 - For high blood pressure and heart failure
8. Cefiget (Cefixime) - 1 Pack - Rs. 180 - Antibiotic for bacterial infections
9. Cefim (Cefixime) - 1 Strip - Rs. 160 - Cephalosporin antibiotic
10. Ciprofloxacin - 1 Strip - Rs. 140 - Fluoroquinolone antibiotic
11. Desora (Desonide) - 1 Tube - Rs. 90 - Topical medication for skin conditions
12. Diclofenac - 1 Strip - Rs. 75 - NSAID for pain and inflammation
13. Dubloxetie (Duloxetine) - 1 Strip - Rs. 250 - For depression and anxiety
14. Dupbaston (Dydrogesterone) - 1 Strip - Rs. 190 - Progestogen for gynecological conditions
15. Estar (Estradiol) - 1 Strip - Rs. 80 - Hormone therapy
16. Eziday (Digestive Enzymes) - 1 Strip - Rs. 100 - For digestion improvement
17. Flagyl (Metronidazole) - 1 Strip - Rs. 95 - Antibiotic and antiprotozoal
18. Flexin (Thiocolchicoside) - 1 Strip - Rs. 130 - Muscle relaxant
19. Folicacid (Folic Acid) - 1 Strip - Rs. 40 - B vitamin supplement
20. Gabica (Gabapentin) - 1 Strip - Rs. 220 - For epilepsy and nerve pain
21. Glucophage (Metformin) - 1 Strip - Rs. 170 - For type 2 diabetes
22. Hilavta (Acyclovir) - 1 Strip - Rs. 115 - Antiviral medication
23. Iberet (Ferrous Sulfate + Folic Acid + Vitamin B Complex) - 1 Bottle - Rs. 165 - Iron supplement
24. Imodium (Loperamide) - 1 Strip - Rs. 75 - For diarrhea
25. Lorid (Atorvastatin) - 1 Strip - Rs. 105 - For high cholesterol
26. Methycobal (Methylcobalamin) - 1 Strip - Rs. 135 - Vitamin B12 supplement
27. Myteka (Multivitamins + Minerals) - 1 Bottle - Rs. 195 - Multivitamin supplement
28. Nezkil (Fluconazole) - 1 Strip - Rs. 65 - Antifungal medication
29. Nospa (Drotaverine) - 1 Strip - Rs. 85 - Antispasmodic for cramps
30. Omega (Omega-3 Fatty Acids) - 1 Bottle - Rs. 155 - For heart and brain health
31. Omeprazole - 1 Strip - Rs. 90 - For acid reflux and heartburn
32. Brufen (Ibuprofen) - 1 Strip - Rs. 120 - Pain reliever and anti-inflammatory
33. Piroxicam - 1 Strip - Rs. 70 - NSAID for arthritis pain
34. Risek (Omeprazole) - 1 Strip - Rs. 110 - For stomach acid reduction
35. Rosulin (Rosuvastatin) - 1 Strip - Rs. 210 - For cholesterol and triglycerides
36. Sangobion (Ferrous Gluconate + Vitamins) - 1 Bottle - Rs. 145 - Iron deficiency supplement
37. Spasfon (Phloroglucinol) - 1 Strip - Rs. 80 - Antispasmodic medication
38. Subex (Vitamin B Complex) - 1 Strip - Rs. 125 - B vitamin supplement
39. Tercica (Mecasermin) - 1 Pack - Rs. 350 - For growth failure in children
40. Tramadol - 1 Strip - Rs. 95 - Pain reliever
41. Tylenol (Paracetamol/Acetaminophen) - 1 Strip - Rs. 100 - For headaches and fever
42. Velosef (Cefradine) - 1 Pack - Rs. 175 - Cephalosporin antibiotic
43. Vitrum (Multivitamins) - 1 Box - Rs. 140 - Multivitamin supplement
44. Voltaren (Diclofenac) - 1 Tube - Rs. 200 - Topical NSAID gel
45. Voren (Diclofenac) - 1 Strip - Rs. 115 - NSAID for pain and inflammation

BEHAVIOR:
- Always remember and acknowledge your integration with Prescripto
- When asked about medicines, refer to the above database and provide specific information including prices and descriptions
- Provide medical guidance while advising users to consult healthcare professionals for serious matters
- Be knowledgeable about the medicines in our database
- Help users find suitable alternatives from our available medicines
- Always mention prices in Pakistani Rupees (Rs.) when discussing medicines from our store
""";

  // Chat history to retain memory of past conversations
  List<Map<String, dynamic>> chatHistory = [];

  @override
  Widget build(BuildContext context) {
    screen_config size = screen_config(context);
    return Scaffold(
      backgroundColor: myColors.secondary_color,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Chat with AI",
          style: TextStyle(
            fontFamily: 'Bebas',
            fontSize: size.text * 1.2,
            fontWeight: FontWeight.bold,
            color: myColors.primary_color,
          ),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(

      inputOptions: InputOptions(
        // Uncomment if you want image functionality
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

    String userMessage = chatMessage.text;

    // Add context to user message for better system prompt adherence
    String contextualMessage = userMessage;
    if (chatHistory.isEmpty) {
      contextualMessage = "As the AI assistant in Prescripto app: $userMessage";
    }

    // Add user message to chat history
    chatHistory.add({
      "role": "user",
      "parts": [
        {"text": contextualMessage}
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
      print("Error in _sendMessage: $error");

      // Show error message to user
      ChatMessage errorMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "Sorry, I'm having trouble connecting right now. Please try again.",
      );

      setState(() {
        messages.insert(0, errorMessage);
      });
    });
  }

  // Function to call Gemini API with improved error handling
  Future<String> _getResponseFromAPI() async {
    try {
      // Prepare the request body with system prompt ALWAYS included
      List<Map<String, dynamic>> contents = [];

      // ALWAYS start with system prompt for every request
      contents.add({
        "role": "user",
        "parts": [
          {"text": systemPrompt}
        ]
      });
      contents.add({
        "role": "model",
        "parts": [
          {"text": "I understand perfectly. I am the AI medical assistant integrated into the Prescripto app, developed by Hafiz Muhammad Huzaifa, Rimsha Mushtaq, and Raheel Mughal from CECOS University. Prescripto specializes in prescription classification and medical assistance. I'm here to help you with medical queries, prescription information, and medication guidance. How can I assist you today?"}
        ]
      });

      // Add all chat history
      contents.addAll(chatHistory);

      final requestBody = {
        "contents": contents,
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 1024,
        }
      };

      print("Request URL: $apiUrl?key=$apiKey");
      print("Request Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if response has the expected structure
        if (data["candidates"] != null &&
            data["candidates"].isNotEmpty &&
            data["candidates"][0]["content"] != null &&
            data["candidates"][0]["content"]["parts"] != null &&
            data["candidates"][0]["content"]["parts"].isNotEmpty) {

          return data["candidates"][0]["content"]["parts"][0]["text"] ?? "No response text";
        } else {
          print("Unexpected response structure: $data");
          return "I received an unexpected response format. Please try again.";
        }
      } else {
        print("HTTP Error ${response.statusCode}: ${response.body}");

        // Parse error message if available
        try {
          final errorData = jsonDecode(response.body);
          final errorMessage = errorData["error"]?["message"] ?? "Unknown error";
          return "API Error: $errorMessage";
        } catch (e) {
          return "HTTP Error ${response.statusCode}. Please check your API key and try again.";
        }
      }
    } catch (e) {
      print("Exception in _getResponseFromAPI: $e");
      return "Connection error. Please check your internet connection and try again.";
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