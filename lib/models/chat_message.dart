
 import 'dart:ui';

class ChatMessage {
    String content;
    int id;
    dynamic chatRoomId;
    ChatUser user;
    String date;

    ChatMessage({
        required this.content,
        required this.user,
        required this.id,
        required this.chatRoomId,
        required this.date
    });

    factory ChatMessage.fromServerJson(Map data){
      return ChatMessage(
          content: data["message"]??'',
          user: data["userRole"] == "RECIPIENT" ? ChatUser.RECIPIENT : ChatUser.SENDER,
          id:  data["id"],
          chatRoomId: data["chatRoomId"],
          date: DateTime.now().toString()
      );
    }

}


enum ChatUser{  SENDER, RECIPIENT }