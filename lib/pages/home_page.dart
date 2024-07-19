import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sammychatbot/models/chat_message.dart';
import 'package:sammychatbot/models/chat_room.dart';
import 'package:sammychatbot/widgets/nav_bar.dart';
import 'package:sammychatbot/riverpod/riverpod_provider.dart';
import 'package:sammychatbot/service/data_service.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  final dataService = DataService();
  bool _isNewChat = false;
  bool _loading = false;
  bool _replyLoading = false;
  final baseColor = const Color.fromARGB(255, 11, 100, 209);
  final _textController = TextEditingController();
  List<ChatMessage> messages = [];
  final scrollController = ScrollController();

  addMessage()async{
    var chatRoomId2 = ref.read(currentChatRoomProvider).chatRoomId;
    var newChatMessage = ChatMessage(
        content: _textController.text,
        user: ChatUser.SENDER, id: 0,
        chatRoomId: chatRoomId2,
        date: chatRoomId2 == 0 || chatRoomId2 ==null ? 'new_chat' : DateTime.now().toString()
    );

    setState(() {
      _replyLoading = true;
    });


   ChatMessage? res = await dataService.addMessage(_textController.text,chatRoomId2);
    setState(() {
      _replyLoading = false;
    });


   if(res  != null){
     setState(() {
       _replyLoading = false;
       messages.insert(0,newChatMessage);
       messages.insert(0,res);
     });

     if(chatRoomId2 == null || chatRoomId2 == 0){//new chat
       setState(() {
         _isNewChat = true;
       });

       ref.read(currentChatRoomProvider.notifier)
           .updateChatRoom(
           chatRoomId: res.chatRoomId,
           title: res.content,
           date: DateTime.now().toString(),
       );

       var chatRoom = ChatRoom(
           chatRoomId: res.chatRoomId,
           title: res.content,
           date: DateTime.now().toString());
       ref.read(recentChatProvider.notifier).add(chatRoom);
     }
   }

   _textController.text = '';
   scrollController.animateTo(
       0, duration: const Duration(seconds: 0),
       curve: Curves.easeOut);
  }


  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();

  }

  _startLoading(){
    setState(() {
      print("..........started_loading");
      _loading = true;
    });
  }

  _stopLoading(){
    setState(() {
      print("..........finished_loading");
      _loading = false;
    });
  }

  _initData(ref){
    ref.listen(currentChatRoomProvider, (prev,next) async {
      // if(!_isNewChat){
      //
      // }
      if(next.date != 'new_chat'){
        _startLoading();
        await dataService.getMessages(next.chatRoomId).then((values){
          setState(() {
            messages = values.reversed.toList();
          });
        });
      }
     _stopLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
  _initData(ref);
    String? date = ref.watch(currentChatRoomProvider).date;
    if(date == 'new_chat'){
      setState(() {
        messages = [];
      });
    }
    const baseColor = Color.fromARGB(255, 11, 100, 209);
    return Scaffold(
      appBar: _appBar(baseColor),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 0,bottom: 10,left: 10,right: 10
        ),
        child:  Column(
        mainAxisSize: MainAxisSize.max,
          children: [
             Expanded(child: _chatMessages(baseColor,ref),),
             const SizedBox(height: 10,),
             _chatInput(baseColor)
          ],
      )),

      drawer: const NavBar(),
    );
  }


  AppBar _appBar(Color baseColor) {
    var title = ref.watch(currentChatRoomProvider).title;
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white
      ),
      title: Text(title != null ? title.length > 20 ?title.substring(0,20):title : 'No Title',
              style: GoogleFonts.acme(
                  color: Colors.white,
                  textStyle: const TextStyle( overflow: TextOverflow.fade,)),
      ),
      centerTitle: true,
      backgroundColor: baseColor,
    );
  }



  Widget _chatMessages(Color baseColor,WidgetRef ref) {
      if(_loading){
        return const Center(
          child: CircularProgressIndicator()
        );
      }
      return _buildMessageList(baseColor);
  }

  ListView _buildMessageList(Color baseColor) {
    return ListView.builder(
      reverse: true,
      controller: scrollController,
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
                maxWidth: 300,
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
            child: Text(messages[index].content??'',style: const TextStyle(
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
                      if(_textController.text.isNotEmpty && !_replyLoading){
                          addMessage();
                      }
                      FocusScope.of(context).unfocus(); // <-- Hide virtual keyboard
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _replyLoading ?
                    const Color.fromARGB(
                        255, 116, 148, 188) : baseColor,
                    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),),
                  child: const Icon(Icons.send, color: Colors.white,size: 20,),
                ),
              )
             ],
           );
  }
}
