
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sammychatbot/models/user.dart';
import 'package:sammychatbot/service/storage_service.dart';

class NavBar extends ConsumerStatefulWidget {
  const NavBar({super.key});

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}


class _NavBarState extends ConsumerState<NavBar>{
  User? _user;

  @override
  void initState() {
    super.initState();
    StorageService().getUserData().then((data){
      setState(() {
        _user = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> recentChats = [
      "Chat About Food",
      "How to Sleep Well",
      "Chat About Food",
      "How to Sleep Well",
      "Chat About Food",
      "How to Sleep Well",
      "Chat About Food",
      "How to Sleep Well",
      "Chat About Food",
      "How to Sleep Well",
      "Chat About Food",
      "How to Sleep Well How to Sleep Well How to Sleep Well",
      "Chat About Food",
      "How to Sleep Well",
    ];
    const baseColor = const Color.fromARGB(255, 11, 100, 209);

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
                    child: Container(
                      child: Text('AS',style: GoogleFonts.acme(textStyle: TextStyle(
                          overflow: TextOverflow.ellipsis,
                        fontSize: 30
                      )),),
                    ),
              ),
            ),
          ),
          Expanded(
             child: ListView.builder(
               padding: EdgeInsets.zero,
              itemCount: recentChats.length,
              itemBuilder: (context,index){
                return Column(
                   children: [ ListTile(
                  onTap: (){
                  },
                  trailing: Icon(Icons.arrow_circle_right, color: baseColor,),
                  title: Text(recentChats[index],style: GoogleFonts.acme(textStyle: TextStyle(
                    overflow: TextOverflow.ellipsis
                  )),),
                ),
                   Divider(
                     color: Colors.grey,
                     indent: 16,
                     endIndent: 16,
                     thickness: 1,
                   )]);
              }))
        ],
      ),
    );
  }


}
