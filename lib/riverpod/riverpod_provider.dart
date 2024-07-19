import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sammychatbot/models/chat_room.dart';
import 'package:sammychatbot/models/recent_chat.dart';

final formLoadStateProvider = StateProvider<bool>((ref) {
  return false;
});

final currentChatRoomProvider = ChangeNotifierProvider<ChatRoom>((ref){
  return ChatRoom(chatRoomId: null, title: 'New Chat', date: 'new_chat');
});

final recentChatProvider = ChangeNotifierProvider<RecentChat>((ref){
  return RecentChat();
});