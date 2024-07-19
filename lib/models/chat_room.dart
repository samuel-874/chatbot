
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

    factory ChatRoom.fromServerJson(Map data){
      return ChatRoom(
          chatRoomId: data["id"],
          title: data["title"]??'No title',
          date: DateTime.now().toString())
      ;
    }

    initChatRoom(){
      chatRoomId = null;
      title = 'New Chat';
      date = 'new_chat';
      notifyListeners();
    }

    updateChatRoom({required int chatRoomId,required title, required String date}){
        this.chatRoomId = chatRoomId;
        this.title = title;
        this.date = date;
        notifyListeners();
    }

    updateChatRoomNotNotify({required int chatRoomId,required title, required String date}){
        this.chatRoomId = chatRoomId;
        this.title = title;
        this.date = date;
    }
}