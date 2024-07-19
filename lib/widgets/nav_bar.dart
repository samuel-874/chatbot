
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sammychatbot/models/chat_room.dart';
import 'package:sammychatbot/models/user.dart';
import 'package:sammychatbot/riverpod/riverpod_provider.dart';
import 'package:sammychatbot/service/data_service.dart';
import 'package:sammychatbot/service/storage_service.dart';

class NavBar extends ConsumerStatefulWidget {
  const NavBar({super.key});

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}


class _NavBarState extends ConsumerState<NavBar>{
  User? _user;
  final _dataService = DataService();

  @override
  void initState() {
    super.initState();
    StorageService().getUserData().then((data){
      setState(() {
        _user = data;
      });
    });

     Future.delayed(Duration.zero,(){
       setRecentChat();
     }) ;
  }

  void setRecentChat() async{
    await _dataService.initRecentChat(ref);
  }

  @override
  Widget build(BuildContext context) {
    const baseColor = Color.fromARGB(255, 11, 100, 209);
    List<ChatRoom> recentChats = ref.watch(recentChatProvider).chatRooms;
    bool isLoading = ref.watch(recentChatProvider).isLoading;

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        // padding: EdgeInsets.zero,
        children: [
         UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: baseColor
            ),
              accountName: Text(_user?.fullName??'N/A',style: const TextStyle(
                letterSpacing: 0.2,
                height: 0.1
              ),),
              accountEmail: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                     child: Text(_user?.email??'',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,)),
                  const SizedBox(width: 20,),
                  GestureDetector(
                    onTap: (){
                      StorageService().clearUserData();
                      Navigator.pushNamed(context, "/login");
                    },
                     child: Text(
                    "Logout",
                    style: GoogleFonts.acme(
                        textStyle: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w600,)
                    ))),
                  const SizedBox(width: 20,),

                ],
              ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                    child: Text( getDefaultProfile(_user?.fullName)??'',
                      style: GoogleFonts.acme(
                          textStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      fontSize: 30
                    )),),
              ),
            ),
          ),
          _buildRecentChatUi(isLoading,recentChats,baseColor),
        Container(
          width: 200,
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(onPressed: (){
            ref.read(currentChatRoomProvider.notifier).initChatRoom();
            Navigator.of(context).pop();
          },style: ElevatedButton.styleFrom(
                  backgroundColor: baseColor,
            ),
            child: const Text('New Chat', style: TextStyle(
              fontSize: 16, color: Colors.white,),),
          ),
        )

        ],
      ),
    );
  }

  Widget _buildRecentChatUi(bool _isLoading,List<ChatRoom> recentChats,Color baseColor){
    return _isLoading ?
    const Expanded(child: Center(child: CircularProgressIndicator()))
        : recentChats.isNotEmpty ?
    Expanded(
        child:(
            ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: recentChats.length,
                itemBuilder: (context,index){
                  return Column(
                      children: [
                        ListTile(
                          onTap: (){
                            ref.read(currentChatRoomProvider.notifier)
                                .updateChatRoom(
                                chatRoomId: recentChats[index].chatRoomId,
                                title: recentChats[index].title,
                                date: DateTime.now().toString());
                            Navigator.of(context).pop();
                          },
                          trailing: Icon(Icons.arrow_circle_right, color: baseColor,),
                          title: Text(
                            recentChats[index].title??'No title',
                            style: GoogleFonts.acme(
                                textStyle: const TextStyle(
                                    overflow: TextOverflow.ellipsis
                                )),),
                        ),
                        const  Divider(
                          color: Colors.grey,
                          indent: 16,
                          endIndent: 16,
                          thickness: 1,
                        )
                      ]);
                }))
    ): Center(
      child: Text('No Recent Chat 📪',
          style: GoogleFonts.acme(
              textStyle: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 24
              )
          )
      ),
    );
  }

  String? getDefaultProfile(String? name){
    if(name == null){
      return 'N/A';
    }

    if(name.isEmpty){
        return 'N/A';
    }

      List<String> nl = name.split(' ');
      if(nl.length == 1){
          if(nl.first.length > 1){
            return "${nl.first[0]} ${nl.first[1]}".toUpperCase();
          }else {
            return nl.first[0];
          }
      }if(nl.length > 1){
        return "${nl.first[0]} ${nl.last[0]}".toUpperCase();
      }
      return 'N/A';
  }

}
