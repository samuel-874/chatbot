import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sammychatbot/models/chat_room.dart';

final formLoadStateProvider = StateProvider<bool>((ref) {
  return false;
});

final currentChatRoomProvider = ChangeNotifierProvider<ChatRoom>((ref){
  return ChatRoom(chatRoomId: null, title: 'New Chat', date: DateTime.now().toString());
});

//current chat we_have a `list of messages`
          //you can push to the list of chat by sending a simple chat message
          // the ai prompt reply is also pushed
          // the entire list of chat is fetched from the server again when the chat room id's changes
// and a chat room .
            //chat room had an id and a title
            //`list of messages` gets updated when you click on the recent chat
            // chat room get updated (for new chat) when response is retrieved