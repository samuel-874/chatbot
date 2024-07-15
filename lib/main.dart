import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sammychatbot/pages/forgotten_password_page.dart';
import 'package:sammychatbot/pages/home_page.dart';
import 'package:sammychatbot/pages/route_authenticated.dart';
import 'package:sammychatbot/pages/signup_page.dart';
import 'package:sammychatbot/pages/splash_screen.dart';
import 'package:sammychatbot/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return OverlaySupport.global(
        child: MaterialApp(
      title: 'Chatbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
            textTheme: TextTheme(
              headlineLarge: GoogleFonts.roboto(fontSize: 60,fontWeight: FontWeight.bold),
              headlineMedium: GoogleFonts.roboto(fontSize: 36,fontStyle: FontStyle.italic),
              headlineSmall: GoogleFonts.roboto(fontSize: 14)
            ),
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 11, 100, 209)),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white),
      initialRoute: "/",
      routes: {
        "/login": (context) => LoginPage(),
        "/signup": (context) => SignupPage(),
        "/home": (context) => RouteAuthenticated(child: HomePage()),
        "/": (context) => SplashScreen(),
        "/forgotten_password": (context) => ForgottenPasswordPage(),
      },
    ));
  }
}
