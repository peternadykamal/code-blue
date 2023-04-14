import 'package:gradproject/services/chat_service.dart';

testThis() async {
  ChatService chatInstance = ChatService();
  await chatInstance.connect();
  chatInstance.listen((message) {
    print(message);
  });
  chatInstance.send("i am not feeling good");
  // chatInstance.disconnect();
}
