import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:assessment_task/login_screen.dart';
import 'package:assessment_task/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

_launchURL() async {
  const url = 'https://buzzevents.co/contact.html';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
 // String clientId="",redirectUrl="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   /* LinkedInLogin.initialize(context,
        clientId: clientId,
        clientSecret: clientId,
        redirectUri: redirectUrl);

    */
  }
  /*loginLinkedIn() async{
//here code to login with linked in
    LinkedInLogin.loginForAccessToken(
        destroySession: true,
        appBar: AppBar(
          title: Text('Demo Login Page'),
        ))
        .then((accessToken) => print(accessToken))
        .catchError((error) {
      print(error.errorDescription);
    });
    LinkedInLogin.getProfile(
        destroySession: true,
        forceLogin: true,
        appBar: AppBar(
          title: Text('Demo Login Page'),
        ))
        .then((profile) {
      print('First name : ${profile.firstName}');
      print('Last name : ${profile.lastName}');
      print('Avatar: ${profile.profilePicture.profilePictureDisplayImage
          .elements.first.identifiers.first.identifier}');
    })
        .catchError((error) {
      print(error.errorDescription);
    });
  }
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              height:300,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(image:
                  AssetImage("assets/background-buz2.png"),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child:  Center(
                  child: Container(
                    child: const Center(child: Image(image: AssetImage("assets/logobuzzeventsf.png"),width: 250, alignment: Alignment.center,)),
                  ),
                ) ,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Row (
              children:<Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex:6,
                  child: Container(
                    height:MediaQuery.of(context).size.height*0.03+30,
                    child: RaisedButton (
                      color: const Color(0xff692062),
                      shape:const RoundedRectangleBorder(
                          side: BorderSide(width: 2,color: Color(0xff692062), ) ,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ) ,
                      onPressed: ()  {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: const Text ( ('Se Connecter') ,style: TextStyle(fontSize:20,color: Colors.white,fontWeight: FontWeight.w300),
                      ) ,
                    ),
                  ),
                ) ,
                Expanded(
                  flex: 1,
                  child: Container(),
                )
              ],
            ),
            Container(
              child: Container(
                height: 20,
              ),
            ),
            Row (
              children:<Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex:6,
                  child: Container(
                    height:MediaQuery.of(context).size.height*0.03+30,
                    child: RaisedButton (
                      color: Colors.white,
                      shape:const RoundedRectangleBorder(
                          side: BorderSide(width: 2,color: Color(0xff692062), ) ,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ) ,
                      onPressed: ()  {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                      },
                      child: const Text ( ('S\'inscrire') ,style: TextStyle(fontSize:20,color: Color(0xff692062),fontWeight: FontWeight.w300),
                      ) ,
                    ),
                  ),
                ) ,
                Expanded(
                  flex: 1,
                  child: Container(),
                )
              ],
            ),

            Expanded (
              flex:2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(flex:3,child: Container(height: 1,color: Colors.grey,)),
                  const Expanded(child: Text(('Ou'),
                    textAlign:TextAlign.center,
                  )),
                  Expanded(flex:3,child: Container(height: 1,color: Colors.grey,)),
                ],),
            ) ,
            Container(
              width:300,
              height: 60,
              child: RaisedButton (
                color: const Color(0xff0e76a8),
                shape:const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ) ,
                onPressed: (){
                  //loginLinkedIn();
                },
                child: Row (
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget>[
                    Image.asset('assets/linkedin_logo.png', width: 25,),
                    Container(width:0.5),
                    Container(
                        child: const Padding(
                          padding: EdgeInsets.only(top:3),
                          child: Text('Continue avec Linkedin', style: TextStyle(fontSize:20,color: Colors.white,fontWeight: FontWeight.normal)),
                        )

                    ),
                  ],
                ),
              ),

            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded (
              flex:1,
              child:Container(

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text ( ('Pour plus d\'informations,') ,
                        style: TextStyle( color: Colors.grey,
                            fontSize: 12
                        )
                    ),
                    GestureDetector (
                        onTap: (_launchURL) ,
                      child: const Text ( (' contactez nous' ), style: TextStyle(color:Color(0xff692062),fontSize: 12),
                      ) ,
                    ),
                  ],

                ),
              ),
            ) ,
          ],
        )
    );
  }
/*  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text( 'No'),
          ),
          new FlatButton(
            onPressed: () => exit(0),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

 */
}

