import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sammychatbot/models/chat_message.dart';
import 'package:sammychatbot/models/chat_room.dart';
import 'package:sammychatbot/models/custom_response.dart';
import 'package:sammychatbot/riverpod/riverpod_provider.dart';
import 'package:sammychatbot/service/http_service.dart';
import 'package:sammychatbot/widgets/notification_card.dart';

class DataService{
    List<ChatMessage> messages = [];
    HttpService httpService = HttpService();

    Future<List<ChatMessage>> getMessages(chat_room_id)async{
        if(chat_room_id != null && chat_room_id > 0 ){
          Response? response = await httpService.get('chat/$chat_room_id/chat_messages',authenticated: true);
            if(response!.statusCode == 200){
                final customResponse = CustomResponse.fromJson(response!.data);
                if(customResponse.data is List){
                  List<ChatMessage> chm = [];
                    customResponse.data.forEach((val){
                      ChatMessage message = ChatMessage.fromServerJson(val);
                      chm.add(message);
                    });
                    return chm;
                }
            }else{
              showOverlayNotification((context){
                return notifcationCard(context, "Error Occurred", "Unable To Retrieve Chat", Icon(Icons.satellite_alt));
              },duration: const Duration(seconds: 4));
            }

        }
        return messages;
    }
    
    Future<ChatMessage?> sendPrompt(String text,chatRoomId)async{
      try {
        Response? response = await httpService.post("chat/prompt", {
          "chatRoomId": chatRoomId,
          "message": text
        });


        if(response!.statusCode! >= 200 ){
            CustomResponse customResponse = CustomResponse.fromJson(response.data??{});
            ChatMessage chatMessage = ChatMessage.fromServerJson(customResponse.data??{});
            return chatMessage;
        }
      }catch (e){
        showOverlayNotification((context){
          return notifcationCard(context, "Error Occurred", "Could not send prompt", const Icon(Icons.error_sharp,color: Colors.red,));

        },duration: const Duration(seconds: 4));
      }

      return null;
    }

    Future<ChatMessage?> addMessage(newMessage,chatRoomId) async{
       return sendPrompt(newMessage, chatRoomId);
    }

    Future<List<ChatRoom>> getRecentChatMessages() async {
      List<ChatRoom> rms = [];
      Response? response = await httpService.get("chat/recent",authenticated: true);
      if(response!.statusCode! >= 200){
          CustomResponse customResponse = CustomResponse.fromJson(response.data);
          if(customResponse.data is List){
              customResponse.data.forEach((room){
                  ChatRoom chatRoom = ChatRoom.fromServerJson(room);
                  rms.add(chatRoom);
              });
          }
      }
      return rms;
    }


    Future<void> initRecentChat(WidgetRef ref) async {
      if(ref.read(recentChatProvider).chatRooms.isEmpty){
          ref.read(recentChatProvider.notifier).toggleLoading(true);
          List<ChatRoom>? chatRoom = await getRecentChatMessages();
          ref.read(recentChatProvider.notifier).addAll(chatRoom);
          ref.read(recentChatProvider.notifier).toggleLoading(false);
      }
      ref.read(recentChatProvider.notifier).toggleLoading(false);//for first call
    }


}