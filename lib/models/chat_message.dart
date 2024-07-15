
 class ChatMessage {
    String content;
    int id;
    int chatRoomId;
    ChatUser user;
    String date;

    ChatMessage({
        required this.content,
        required this.user,
        required this.id,
        required this.chatRoomId,
        required this.date
    });

}


enum ChatUser{  SENDER, RECIPIENT }