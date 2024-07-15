import 'package:flutter/material.dart';
import 'package:sammychatbot/models/user.dart';
import 'package:sammychatbot/service/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () async {
      final preference = await StorageService();
      final rememberMe = await preference.existingKey("remember_me");
     preference.getUserData().then((userData){
        var accessToken = userData.token;
        if(accessToken != null && !JwtDecoder.isExpired(accessToken)){
          Navigator.of(context).pushNamed("/home"); //returning
        }else if(rememberMe){
          Navigator.of(context).pushNamed("/login");
        }else{
          Navigator.of(context).pushNamed("/signup");//first timer
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: false,
            child: Center(
                child: SizedBox(
              height: 160,
              width: 160,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                  )),
            ))));
  }
}