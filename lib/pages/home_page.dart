import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sammychatbot/models/chat_message.dart';
import 'package:sammychatbot/models/user.dart';
import 'package:sammychatbot/pages/nav_bar.dart';
import 'package:sammychatbot/riverpod/riverpod_provider.dart';
import 'package:sammychatbot/service/storage_service.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  User? _user;

  bool _fetching = false;
  bool _loading = false;
  final baseColor = const Color.fromARGB(255, 11, 100, 209);
  final Future<User> _future = StorageService().getUserData();
  final _textController = TextEditingController();
  List<ChatMessage> messages = [
    ChatMessage(content: "Hello", user: ChatUser.SENDER, date: DateTime.now().toString(),id: 0,chatRoomId: 0),
    ChatMessage(content: "Hello", user: ChatUser.SENDER, date: DateTime.now().toString(),id: 0,chatRoomId: 0),
    ChatMessage(content: "Hello", user: ChatUser.RECIPIENT, date: DateTime.now().toString(),id: 0,chatRoomId: 0),
    ChatMessage(content: "Hello", user: ChatUser.RECIPIENT, date: DateTime.now().toString(),id: 0,chatRoomId: 0),
    ChatMessage(content: "Hello", user: ChatUser.RECIPIENT, date: DateTime.now().toString(),id: 0,chatRoomId: 0),
    ChatMessage(content: "Hello", user: ChatUser.RECIPIENT, date: DateTime.now().toString(),id: 0,chatRoomId: 0),
    ChatMessage(content: "Hello", user: ChatUser.SENDER, date: DateTime.now().toString(),id: 0,chatRoomId: 0),
    ChatMessage(content: "Hello", user: ChatUser.SENDER, date: DateTime.now().toString(),id: 0,chatRoomId: 0),
    ChatMessage(content: "Hello", user: ChatUser.SENDER, date: DateTime.now().toString(),id: 0,chatRoomId: 0),
  ];

  addMessage(){
    String prompt = _textController.text;
    setState(() {
      var newChatMessage = ChatMessage(
          content: _textController.text,
          user: ChatUser.SENDER, id: 0,
          chatRoomId: 0,date: DateTime.now().toString());
      messages.add(newChatMessage);
    });
    _textController.text = '';

    String aiResponse = 'DEMO RESPONSE';//get make request to the backend

    setState(() {
      var aiResponse = ChatMessage(
          content: "DEMO RESPONSE",
          user: ChatUser.RECIPIENT, id: 0,
          chatRoomId: 0, date: "2024-01-1");
      messages.add(aiResponse);
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _future.then((user) {
        setState(() {
          _user = user;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    const baseColor = const Color.fromARGB(255, 11, 100, 209);
    return Scaffold(
      appBar: _appBar(baseColor,ref),
      body: Padding(
        padding: const EdgeInsets.only(top: 0,bottom: 10,left: 10,right: 10),
        child:  Column(
        mainAxisSize: MainAxisSize.max,
          children: [
             Expanded(child: _chatMessages(baseColor),),
             const SizedBox(height: 10,),
             _chatInput(baseColor)
          ],
      )),

      drawer: NavBar(),
    );
  }

  AppBar _appBar(Color baseColor,WidgetRef ref) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white
      ),
      title: Text(ref.watch(currentChatRoomProvider).title??'New Chat',
              style: GoogleFonts.acme(
                  color: Colors.white,
                  textStyle: const TextStyle( overflow: TextOverflow.fade)),
      ),
      centerTitle: true,
      backgroundColor: baseColor,
    );
  }



  ListView _chatMessages(Color baseColor) {
    return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context,index){
              return Align(
                alignment: messages[index].user == ChatUser.SENDER
                    ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                  margin: EdgeInsets.only(
                      top: index == 0? 10.0 : (
                          messages[index -1].user == messages[index].user? 1.0: 10.0
                        ),
                      bottom: index == messages.length -1 ? 10.0 : (
                          messages[index+1].user == messages[index].user
                              ?
                          0: 10.0
                      ),),
                  constraints: const BoxConstraints(
                    maxWidth: 250
                  ),
                  decoration: BoxDecoration(
                    color:  messages[index].user == ChatUser.SENDER ? Colors.green : baseColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(10),
                      topRight: const Radius.circular(10),
                      bottomLeft: messages[index].user == ChatUser.SENDER ? Radius.circular(10) : Radius.zero,
                      bottomRight: messages[index].user == ChatUser.RECIPIENT ? Radius.circular(10) : Radius.zero,
                    ),
                  ),
                  child: Text(messages[index].content,style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  ),),
                ),
              );
            },
          );
  }

  Row _chatInput(Color baseColor) {
    return Row(
             children: [
                Expanded(child: TextField(
                  controller: _textController,
                 decoration: InputDecoration(
                      hintText: "input a prompt...",
                     border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8)
                     )
                 ),
               )),
              const SizedBox(width: 4,),
              SizedBox(
                height: 52,
                width: 65,
                child:  ElevatedButton(
                    onPressed: (){
                      if(_textController.text.isNotEmpty && !_loading){
                          addMessage();
                      }
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: baseColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),

                  ),
                  child: const Icon(Icons.send, color: Colors.white,size: 20,),
                ),
              )
             ],
           );
  }
}
