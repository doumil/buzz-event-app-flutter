import 'dart:convert';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:assessment_task/forgotPassEmail.dart';
import 'package:assessment_task/reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Verificatoin extends StatefulWidget {
  const Verificatoin({ Key? key }) : super(key: key);

  @override
  _VerificatoinState createState() => _VerificatoinState();
}
class _VerificatoinState extends State<Verificatoin> {
  late var id_buzz;
  late String email="";
  late String phone="";
  getCodereset() async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    id_buzz = sessionLogin.getInt("id_buzz");
    email   = sessionLogin.getString("email").toString();
    phone   = sessionLogin.getString("phone").toString();
  }
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;
  String _code = '';
  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;
  var codeRandom = Random();
  int codeReset=0;
  int min=100000,max=999999;
  void resend() {
    setState(() {
      _isResendAgain = true;
      resendcode();
    });
    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState((){
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        }
        else {
          _start--;
        }
      });
    });
  }
  resendcode() async {
    setState(() {
      getCodereset();
    });
     if(email!="") {
       codeReset = min + codeRandom.nextInt(max - min);
       await http.post(
           Uri.parse('https://okydigital.com/buzz_login/check.php'), body: {
         'email': email,
         'codeReset': codeReset.toString()
       });
       sendMail(codeReset);
     }
    if(phone!="") {
      codeReset = min + codeRandom.nextInt(max - min);
      await http.post(
          Uri.parse('https://okydigital.com/buzz_login/checkphone.php'), body: {
        'phone': phone,
        'codeReset': codeReset.toString()
      });
      sendPhone(codeReset);
    }
  }
  sendPhone(int ccReset) async {
    print("suc");
  }
  sendMail(int ccReset) async {
    String username = 'yassinedoumil96@gmail.com';
    String password = 'jysjamalyassine9669.com';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'team buzzevvent')
      ..recipients.add(email)
      ..subject = 'Reset Password verification : ${DateTime.now().hour}:${DateTime.now().minute}'
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
    setState(() {
    });
  }
  verify() async{
    setState(() {
      _isLoading = true;
    });
    //const oneSec = Duration(milliseconds: 1000);
    //_timer = new Timer.periodic(oneSec, (timer) {
    //print(_code);
    var response = await http.post(Uri.parse('https://okydigital.com/buzz_login/checkcodereset.php'),body:{
      'id_buzz':id_buzz.toString(),
    });
    print(id_buzz);
    var res = jsonDecode(response.body);
    print(res['codereset']);
    if(res['codereset']==_code) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
        Fluttertoast.showToast(msg: "opération réussie",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetScreen()));
      });
    }
    else{
      _isLoading = false;
      _isVerified = false;
      Fluttertoast.showToast(msg: "code incorrect réessayez",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPass()));
    }
    //});
  }
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex++;
        if (_currentIndex == 3)
          _currentIndex = 0;
      });
    });
    getCodereset();
    super.initState();
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
      onWillPop:_onWillPop,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: AnimatedOpacity(
                                opacity: _currentIndex == 0 ? 1 : 0,
                                duration: Duration(seconds: 1,),
                                curve: Curves.linear,
                                child: Image.asset('assets/intro_photo1.png', width: 80,height: 80),                            ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: AnimatedOpacity(
                                opacity: _currentIndex == 1 ? 1 : 0,
                                duration: Duration(seconds: 1),
                                curve: Curves.linear,
                                child: Image.asset('assets/intro_photo2.png', width: 100,height: 100),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: AnimatedOpacity(
                                opacity: _currentIndex == 2 ? 1 : 0,
                                duration: Duration(seconds: 1),
                                curve: Curves.linear,
                                child: Image.asset('assets/intro_photo3.png', width: 100,height: 100),
                              ),
                            )
                          ]
                      ),
                    ),
                    SizedBox(height: 30,),
                    FadeInDown(
                        duration: Duration(milliseconds: 500),
                        child: Text("Verification", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Color(0xff692062)),)),
                    SizedBox(height: 30,),
                    FadeInDown(
                      delay: Duration(milliseconds: 500),
                      duration: Duration(milliseconds: 500),
                      child: Text("Veuillez entrer le code à 6 chiffres envoyé à\n ${email}${phone}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade500, height: 1.5),),
                    ),
                    SizedBox(height: 30,),
                    // Verification Code Input
                    FadeInDown(
                      delay: Duration(milliseconds: 600),
                      duration: Duration(milliseconds: 500),
                      child: VerificationCode(
                        length: 6,
                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                        underlineColor: Colors.black,
                        keyboardType: TextInputType.number,
                        underlineUnfocusedColor: Colors.black,
                        onCompleted: (value) {
                          setState(() {
                            _code = value;
                          });
                        },
                        onEditing: (value) {},
                      ),
                    ),
                    SizedBox(height: 20,),
                    FadeInDown(
                      delay: Duration(milliseconds: 700),
                      duration: Duration(milliseconds: 500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't resive the OTP?", style: TextStyle(fontSize: 14, color: Colors.grey.shade500),),
                          TextButton(
                              onPressed: () {
                                if (_isResendAgain) return;
                                resend();
                              },
                              child: Text(_isResendAgain ? "Try again in " + _start.toString() : "Resend", style: TextStyle(color: Colors.blueAccent),)
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50,),
                    FadeInDown(
                      delay: Duration(milliseconds: 800),
                      duration: Duration(milliseconds: 500),
                      child: MaterialButton(
                        elevation: 0,
                        onPressed:() {
                          if(_code.length <6){
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => ResetScreen()));
                          }
                          else
                            {
                              verify();
                            }
                        },
                        color: Color(0xff692062),
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                        height: 50,
                        child: _isLoading ? Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 3,
                            color: Colors.black,
                          ),
                        ) : _isVerified ? Icon(Icons.check_circle, color: Colors.white, size: 30,) : Text("Verify", style: TextStyle(color: Colors.white),),
                      ),
                    )
                  ],)
            ),
          )
      ),
    );
  }
}