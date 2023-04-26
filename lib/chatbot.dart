import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradproject/services/chat_service.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/style.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

// ignore: camel_case_types
class chatbotPage extends StatefulWidget {
  const chatbotPage({super.key});

  @override
  State<chatbotPage> createState() => _chatbotPageState();
}

// ignore: camel_case_types
class _chatbotPageState extends State<chatbotPage> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  late ChatService _chatInstance;

  @override
  void initState() {
    super.initState();
    startChatBot();
  }

  void startChatBot() async {
    _chatInstance = ChatService();
    await _chatInstance.connect();
    _chatInstance.listen((message) {
      final botMessage = types.TextMessage(
        author: const types.User(id: 'bot'),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: message,
      );
      _addMessage(botMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mycolors.splashback,
        leading: InkWell(
            onTap: () {
              _chatInstance.disconnect();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => sosPage()));
            },
            child: Icon(Icons.arrow_back, color: Mycolors.textcolor)),
        title: Row(
          children: [
            Text("Blu: the chatbot ",
                style: TextStyle(color: Mycolors.textcolor))
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        )),
      ),
      body: Chat(
        theme: DefaultChatTheme(
          backgroundColor: Mycolors.fillingcolor,
          primaryColor: Mycolors.textcolor,
          secondaryColor: Mycolors.splashback,
          sentMessageBodyTextStyle:
              TextStyle(color: Colors.white, fontSize: 15),
          receivedMessageBodyTextStyle:
              TextStyle(color: Mycolors.textcolor, fontSize: 15),
          inputMargin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          inputBorderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          inputBackgroundColor: Mycolors.chatInput,
        ),
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        showUserAvatars: true,
        avatarBuilder: (String id) => imageUrl("assets/images/chatbotpic.svg"),
      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    // Send user's message to chatbot
    _chatInstance.send(message.text);

    // Add chatbot's response as a new message
    final botMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(botMessage);
  }
}

Widget imageUrl(string) {
  return CircleAvatar(
    backgroundColor: Mycolors.buttonsos,
    radius: 23.5,
    child: Stack(
      children: [SvgPicture.asset(string)],
    ),
  );
}
