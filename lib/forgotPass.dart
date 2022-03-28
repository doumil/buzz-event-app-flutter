import 'dart:math';
import 'package:assessment_task/submitcode_screen.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widget/customClipper.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:mailer/mailer.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController emailctrl = TextEditingController();
  var codeRandom = Random();
  GlobalKey<FormState> _keyforg = new GlobalKey<FormState>();
  bool verifyButton = false;
  late String verifyLnk;
  int codeReset=0;
  int min=1000,max=9999;
  saveCodereset(int id) async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    sessionLogin.setInt("codereset", id);
  }
  //form != null && !form.validate()
  forgetPassValid(){
    var formdata = _keyforg.currentState;
    if(formdata != null && !formdata.validate()){
      return "make sure all the fields are valide";
    }else if(formdata != null && formdata.validate()){
      checkUser();
    }
  }


  Future checkUser()async{
/*
    var url = "https://okydigital.com/buzz_login/check.php";
    var data = {
      "email": emailctrl.text.trim(),
    };
    var res = await http.post(Uri.parse(url), body: data);
    var resbody = await jsonDecode(res.body.toString());
    if (resbody == "emailfound") {
      Fluttertoast.showToast(
          msg: "Entrez le code que vous avez reçu par e-mail",
          toastLength: Toast.LENGTH_SHORT);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    }
     else if (resbody== "Invalidemail") {
        Fluttertoast.showToast(msg: "This email is incorrect",
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 12,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.deepPurple,
            textColor: Colors.white);
      }
     else {
      Fluttertoast.showToast(msg: "Erreur, réessayez plus tard",
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 12,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.deepPurple,
          textColor: Colors.white);
      }
 */
    codeReset= min+codeRandom.nextInt(max - min);
    print(codeReset);
    saveCodereset(codeReset);
    sendMail(codeReset);
    }
  sendMail(int ccReset) async {
    String username = 'yassinedoumil96@gmail.com';
    String password = 'jysjamalyassine9669.com';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'team buzzevvent')
      ..recipients.add(emailctrl.text.toString())
      ..subject = 'Reset Password verification : ${DateTime.now()}'
      ..html = "<h1>Votre ocde est :</h1>\n<p>${ccReset}</p>";
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
    var connection = PersistentConnection(smtpServer);
    // send the equivalent message
    await connection.send(message);
    // close the connection
    await connection.close();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Verificatoin()));
  }
  int newPass = 0;
  Future resetPass (String verifyLnk)async{
    var response = await http.post(Uri.parse(verifyLnk));
    var link = jsonDecode(response.body);
    setState(() {
      newPass = link;
      verifyButton = false;
    });
    //print(link);
    Fluttertoast.showToast(msg: "Your password has been reset : $newPass",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                height:200,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(image:
                    AssetImage("assets/background-buz2.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  child:  Center(
                    child: Container(
                      child: const Center(child: Image(image: AssetImage("assets/logobuzzeventsf.png"),width: 230, alignment: Alignment.center,)),
                    ),
                  ) ,
                ),
              ),
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: Container(
                    child: Transform.rotate(
                      angle: -pi / 3.5,
                      child: ClipPath(
                        clipper: ClipPainter(),
                        child: Container(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width,

                        ),
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 300,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text('Réinitialisez le mot de passe',
                          style: TextStyle(fontSize: 20,color: Color(0xff692062),fontWeight: FontWeight.bold),
                        ),
                      ),

                      Form(
                        key: _keyforg,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                      controller: emailctrl,
                                      validator: (value) {
                                        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                                        if (value == null || value.trim().isEmpty) {
                                          return 'Champ obligatoire';
                                        }
                                        else{
                                          RegExp regex =  RegExp(pattern.toString());
                                          if(!regex.hasMatch(value)){
                                            return 'Entrer une Adresse Email valide';
                                          }
                                        }
                                        return null;
                                      },
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed:(){
                          //Navigator.push(
                            //  context, MaterialPageRoute(builder: (context) => Verificatoin()));
                            forgetPassValid();
                            //print(codeReset.nextInt(999999));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            color: Color(0xff692062),
                          ),
                          child: Text('Envoyez', style: TextStyle(fontSize: 20, color: Colors.white),),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                          child:
                          Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Text('',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
  showToast(String msg, {required int duration, required int gravity}){

    showToast(msg, duration: duration, gravity: gravity);

  }
}

