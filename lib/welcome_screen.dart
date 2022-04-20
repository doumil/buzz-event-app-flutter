import 'dart:convert';
import 'package:assessment_task/login_screen.dart';
import 'package:assessment_task/signup_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:linkedin_auth/linkedin_auth.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';

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
  String clientId="",redirectUrl="";
  String code="MA",code1="212";
  var lEmail,lFirstname,lLastname,lId;
  bool isLoading = true;
  @override
  void initState() {
    isLoading = true;
    super.initState();

  }
  Future checkUser()async{
    setState(() {
    });
    print(lEmail.toString());
    print(lFirstname);
    print(lLastname);
    print(lId);
    var response = await http.post(Uri.parse('https://okydigital.com/buzz_login/loginlinkedin.php'),body:{
      "email":lEmail.toString(),
      "first_name":lFirstname.toString(),
      "last_name":lLastname.toString(),
      "company":"add company",
      "phone": "+${code1},${code},600000000",
      "password":lId.toString(),
    });
    var resbody = jsonDecode(response.body.toString());
    if(resbody["status"]=="Success"){
      //login linkedin
      saveSession(
          int.parse(resbody['id']),
          resbody['email'],
          resbody['fname'],
          resbody['lname'],
          resbody['company'],
          resbody['phone']);
      Fluttertoast.showToast(
          msg: "Connecté avec succès", toastLength: Toast.LENGTH_SHORT);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    else if(resbody["status"]=="added")
        {
          //signup and login
          saveSession(
              int.parse(resbody['id']),
              resbody['email'],
              resbody['fname'],
              resbody['lname'],
              resbody['company'],
              resbody['phone']);
          Fluttertoast.showToast(
              msg: "Connecté avec succès", toastLength: Toast.LENGTH_SHORT);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
  saveSession(int id, String email, String fname, String lname, String company,
      String phone) async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    sessionLogin.setInt("id", id);
    sessionLogin.setString("email", email);
    sessionLogin.setString("fname", fname);
    sessionLogin.setString("lname", lname);
    sessionLogin.setString("company", company);
    sessionLogin.setString("phone", phone);
  }
  loginLinkedIn() async{
      //here code to login with linked in
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text("se connecter avec linkedin"),
                backgroundColor:const Color(0xff0e76a8),
                leading: CloseButton(),
              ),
              body:  LinkedInLoginView(
                clientId: "77k2mc7uf5821x",
                redirectUrl: "https://buzzevents.com",
                onError: (String error) {
                  print(error);
                },
                bypassServerCheck: true,
                clientSecret: "TfIZetwGspWYh9uS",
                onTokenCapture: (token) {
                  getProfile (token.token.toString());
                },
                onServerResponse: (res) {
                  var parsed = json.decode(res.body);
                  return AccessToken(parsed["token"], parsed["expiry"]);
                },
              )
          )
      ),
    );
  }
  getProfile (var tokenProfile) async {
    try {
      //get simple profile
       lEmail =await LinkedInService.getEmailAddress(tokenProfile);
       var lProfile =await LinkedInService.getLiteProfile(tokenProfile);
       lFirstname=lProfile.firstName.text;
       lLastname=lProfile.lastName.text;
       lId=lProfile.id.toString();
       //send info to check email
      checkUser();
    } on LinkedInException catch (e) {
      print(e.cause);
    }
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Êtes-vous sûr'),
        content: new Text('Voulez-vous quitter une application'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Non'),
          ),
          new FlatButton(
            onPressed: () =>SystemNavigator.pop(),
            child: new Text('Oui '),
          ),
        ],
      ),
    )) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                    loginLinkedIn();
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
      ),
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

