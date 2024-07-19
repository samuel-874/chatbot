import 'package:flutter/widgets.dart';
import 'package:sammychatbot/models/chat_room.dart';

class RecentChat extends ChangeNotifier {

  final chatRooms = <ChatRoom>[];
  bool isLoading = true;

  add(ChatRoom newChatRoom){
    chatRooms.insert(0,newChatRoom);
    notifyListeners();
  }
  addAll(List<ChatRoom> newChatRoom){
    chatRooms.addAll(newChatRoom);
    notifyListeners();
  }


  toggleLoading(bool loading){
    isLoading = loading;
    notifyListeners();
  }
}


// 1. infinite scroll on recent chat
// 2. Implement markdown
// 3. infinite scroll on chat history
// 4. new chat
