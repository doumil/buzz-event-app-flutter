// @dart=2.9
import 'dart:io';
import 'package:assessment_task/firstPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'language/trantlations.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = new PostHttpOverrides();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  var id=prefs.getInt('id');
  prefs.setString("lang","FR");
  runApp(GetMaterialApp(home: email == null || id==null? MyApp() : HomeScreen(),
   translations: Translation(),
    locale: Locale("FR"),
    fallbackLocale: Locale("ANG"),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = new PostHttpOverrides();
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'buzz event',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      home: FirsPage(),
    );
  }
}
class PostHttpOverrides extends HttpOverrides{
  @override
HttpClient createHttpClient(SecurityContext context){
  return super.createHttpClient(context)
    ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
}
}