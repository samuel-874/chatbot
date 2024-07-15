
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sammychatbot/service/storage_service.dart';
import 'package:sammychatbot/widgets/notification_card.dart';

class RouteAuthenticated extends StatelessWidget{

  Widget? child;
  RouteAuthenticated({
    required this.child
  });


  @override
  Widget build(BuildContext context) {
    StorageService().getUserData().then((userData){
      var accessToken = userData.token;
      if(accessToken == null){
        showOverlayNotification((context){
          return notifcationCard(context,
              "Welcome ",
              "Please Login To Continue",
              const Icon(Icons.warning,color: Colors.amberAccent,));
        },duration: const  Duration(seconds: 4) );
        Navigator.of(context).pushNamed("/login");
      }else if(JwtDecoder.isExpired(accessToken)){
          _showAuthDialog(context);
      }
    });
      return child!;
  }
  
  _showAuthDialog(context){
    showDialog(context: context, builder: (BuildContext context){
        return Dialog(
            shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
            ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20,left: 20, right: 20),
              child: Column(
                children: [
                  const Text(
                    "Session Timeout Please Login to Continue",
                    style: TextStyle(fontFamily: 'Roboto'),),
                  const Spacer(),
                  SizedBox(
                    width: 220,
                    height: 40,
                    child:  ElevatedButton(onPressed: (){
                      Navigator.of(context).pushNamed("/login");
                    },style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 11, 100, 209)),
                        child: const Text("Login",
                          style: TextStyle(color: Colors.white),)
                    ),
                  )
                ],
              ),
            ),
          ),
        );
    }, barrierDismissible: false);
  }
}