
import 'package:flutter/material.dart';

class ChatRoom extends ChangeNotifier{
    dynamic chatRoomId;
    String? title;
    String? date;

    ChatRoom({
      required this.chatRoomId,
      required this.title,
      required this.date,
    });

    initChatRoom(){
      chatRoomId = null;
      title = 'New Chat';
      date = DateTime.now().toString();
    }

    updateChatRoom({required int chatRoomId,required title, required String date}){
        chatRoomId = chatRoomId;
        title = title;
        date = date;
    }
}