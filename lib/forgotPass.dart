import 'dart:math';
import 'Widget/customClipper.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController emailctrl = TextEditingController();

  GlobalKey<FormState> _keyforg = new GlobalKey<FormState>();
  bool verifyButton = false;
  late String verifyLnk;

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
    var response = await http.post(Uri.parse('http://192.168.1.126/buzz_login/check.php'),
        body: {
          'email':emailctrl.text.trim()
        });

    var link = jsonDecode(response.body);
    if(link=="Invalidemail"){
      Fluttertoast.showToast(msg: "This email is incorrect",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white);
    }else{
      setState(() {
        verifyLnk = link;
        verifyButton = true;
      });
      //sendMail();

      Fluttertoast.showToast(msg: "Check your email inbox",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white);
    }
    print(link);

  }




 /* sendMail() async {
    String username = 'amine.faouzi911@gmail.com';
    String password = '123456';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    //final message = Message()
      //..from = Address(username)
      //..recipients.add('amine.norman12@gmail.com')
      //..subject = 'Reset Password verification link from norm: ${DateTime.now()}'
      //..html = "<h1>Test</h1>\n<p><a href='$verifyLnk'> Click me to verify </a></p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');

    }
  }

  */


  int newPass = 0;
  Future resetPass (String verifyLnk)async{
    var response = await http.post(Uri.parse(verifyLnk));
    var link = jsonDecode(response.body);
    setState(() {
      newPass = link;
      verifyButton = false;
    });
    print(link);
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
                          style: TextStyle(fontSize: 25,color: Color(0xff692062)),

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
                          forgetPassValid();
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

