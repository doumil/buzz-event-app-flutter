import 'dart:convert';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:assessment_task/reset_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  const Verificatoin({Key? key}) : super(key: key);

  @override
  _VerificatoinState createState() => _VerificatoinState();
}

class _VerificatoinState extends State<Verificatoin> {
  late var id_buzz;
  late String email = "", secemail = "", secphone = "";
  late String phone = "0000";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  getCodereset() async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    id_buzz = sessionLogin.getInt("id_buzz");
    email = sessionLogin.getString("emailRP").toString();
    phone = sessionLogin.getString("phoneRP").toString();
    if (email != "") {
      var ss = email.split("@");
      List<String> list1 = [];
      ss.forEach((e) {
        list1.add(e);
      });
      secemail = "${email.substring(0, 2)}***********@${list1.elementAt(1)}";
    } else if (phone != "") {
      var ss = phone.split(",");
      List<String> list1 = [];
      ss.forEach((e) {
        list1.add(e);
      });
      var pp = "${list1.elementAt(2)}";
      secphone = "0${pp.substring(0, 1)}******${pp.substring(list1.elementAt(2).length-2,list1.elementAt(2).length)}";
    }
  }

  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;
  String _code = '';
  late Timer _timer;
  int _start = 60;
  int _currentIndex = 0;
  var codeRandom = Random();
  int codeReset = 0;
  String codeResetCr = "";
  int min = 100000, max = 999999;
  void resend() {
    setState(() {
      _isResendAgain = true;
      resendcode();
    });
    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start = 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  resendcode() async {
    setState(() {
      getCodereset();
    });
    if (email != "") {
      codeReset = min + codeRandom.nextInt(max - min);
      await http.post(Uri.parse('https://okydigital.com/buzz_login/check.php'),
          body: {'email': email, 'codeReset': codeReset.toString()});
      sendMail(codeReset);
    }
    if (phone != "") {
      var ss = phone.split(",");
      List<String> list1 = [];
      ss.forEach((e) {
        list1.add(e);
      });
      var phoneformat = "${list1.elementAt(0)}${list1.elementAt(2)}";
      print('################');
      print(phoneformat);
      print('################');
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneformat,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print("----------------");
          print(e);
          print("----------------");
        },
        codeSent: (String verificationId, int? resendToken) async {
          print("----------------code has sent ${verificationId}");
          codeResetCr = verificationId;
          print(")))))))))))))))))))))))))))");
          print(codeResetCr);
          await http.post(
              Uri.parse('https://okydigital.com/buzz_login/checkphone.php'),
              body: {'phone': phone, 'codeReset': verificationId});
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      //codeReset = min + codeRandom.nextInt(max - min);

      //sendPhone(codeReset);
    }
  }

  sendMail(int ccReset) async {
    String username = 'buzzeventteam@gmail.com';
    String password = 'sfhfjpllnwyldlzk';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'team Buzzevent')
      ..recipients.add(email.toString())
      ..subject = 'Reset Password verification'
      ..html = '''<td align='center'>
    <center style='width:100%'>
        <table role='presentation' border='0' class='m_8320516796181038697phoenix-email-container' cellspacing='0' cellpadding='0' width='512' bgcolor='#FFFFFF'
               style='background-color:#ffffff;margin:0 auto;max-width:512px;width:inherit'>
            <tbody>
            <tr>
                <td bgcolor='#692062' style='background-color:#692062;padding:12px;border-bottom:1px solid #ececec'>
                    <table role='presentation' border='0' cellspacing='0' cellpadding='0' width='100%' style='width:100%!important;min-width:100%!important'>
                        <tbody>
                        <tr>
                            <td align='left' valign='middle'>
                                <a href='' style='color:#0073b1;display:inline-block;text-decoration:none' target='_blank' data-saferedirecturl=''>
                                    <img alt='Buzzevent' border='0' src='https://buzzevents.co/frontnew/images/logo-buzzeventsf.png' height='50' width='200' style='outline:none;color:#ffffff;text-decoration:none' class='CToWUd'>
                                </a>
                            </td>
                            <td valign='middle' width='100%' align='right'><a href='' target='_blank' data-saferedirecturl=''>
                                <table role='presentation' border='0' cellspacing='0' cellpadding='0' width='100%'>
                                    <tbody>
                                    </tbody>
                                </table>
                            </a>
                            </td>
                            <td width='1'>&nbsp;</td>
                        </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table role='presentation' border='0' cellspacing='0' cellpadding='0' width='100%'>
                        <tbody>
                        <tr>
                            <td style='padding:20px 24px 10px 24px'> <table role='presentation' border='0' cellspacing='0' cellpadding='0' width='100%'> <tbody> <tr> <td style='padding-bottom:20px'>
                                <h2 style='margin:0;color:#262626;font-weight:700;font-size:20px;line-height:1.2'>
                                    Bounjour
                                </h2>
                            </td>
                            </tr>
                            <tr>
                                <td style='padding-bottom:20px'>
                                    <p style='margin:0;color:#4c4c4c;font-weight:400;font-size:16px;line-height:1.25'>
                                        Nous avons reçu une demande de réinitialisation du mot de passe de votre  
                                         compte <span class='il'> Buzzevvent.</span>
                                    </p>
                                </td>
                            </tr>
                            <tr>
                                <td style='padding-bottom:20px'>
                                    <h2 style='margin:0;color:#262626;font-weight:700;font-size:24px;line-height:1.167'>
                                        ${ccReset}
                                    </h2>
                                </td>
                            </tr>
                            <tr>
                                <td style='padding-bottom:20px'>
                                    <p style='margin:0;color:#4c4c4c;font-weight:400;font-size:16px;line-height:1.25'>
                                       Entrez ce code pour terminer la réinitialisation.
                                    </p>
                                </td>
                            </tr>
                            <tr>
                                <td style='padding-bottom:20px'> <p style='margin:0;color:#4c4c4c;font-weight:400;font-size:16px;line-height:1.25'>
                                    Merci de nous aider à sécuriser votre compte.
                                </p>
                                    <p style='margin:0;color:#4c4c4c;font-weight:400;font-size:16px;line-height:1.25'>
                                    L'équipe Buzzevvent
                                    </p>
                                </td>
                            </tr>
                            </tbody>
                            </table>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <table role='presentation' border='0' cellspacing='0'  cellpadding='0' width='100%'  bgcolor='#EDF0F3' align='center' style='background-color:#edf0f3;padding:0 24px;color:#6a6c6d;text-align:center'>
                        <tbody>
                        <tr>
                            <td align='center' style='padding:16px 0 0 0;text-align:center'>

                                <div class='container'>
                                    <p>  Copyrights © 2020  </p>
                                </div>
                            </td>
                    </table>
                </td>
            </tr>
            </tbody>
        </table>
    </center>
</td>''';
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
    // await connection.send(message);
    // close the connection
    await connection.close();
  }

  verifySms() async {
    setState(() {
      _isLoading = true;
    });
    //const oneSec = Duration(milliseconds: 1000);
    //_timer = new Timer.periodic(oneSec, (timer) {
    //print(_code);
    var response = await http.post(
        Uri.parse('https://okydigital.com/buzz_login/checkcodereset.php'),
        body: {
          'id_buzz': id_buzz.toString(),
        });
    print(id_buzz);
    var res = jsonDecode(response.body);
    print("leeeeeeeength:============> ");
    print(res['codereset'].toString().length);
    if (res['codereset'].toString().length == 6) {
      verify();
    } else {
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: res['codereset'].toString(),
          smsCode: _code.toString(),
        );
        await _auth.signInWithCredential(credential);
        setState(() {
          _isLoading = false;
          _isVerified = true;
          Fluttertoast.showToast(
              msg: "opération réussie",
              toastLength: Toast.LENGTH_SHORT,
              fontSize: 12,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.black,
              textColor: Colors.white);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ResetScreen()));
        });
      } catch (e) {
        _isLoading = false;
        _isVerified = false;
        Fluttertoast.showToast(
            msg: "le code OTP est incorrect",
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 12,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white);
      }
    }
  }

  verify() async {
    setState(() {
      _isLoading = true;
    });
    //const oneSec = Duration(milliseconds: 1000);
    //_timer = new Timer.periodic(oneSec, (timer) {
    //print(_code);
    var response = await http.post(
        Uri.parse('https://okydigital.com/buzz_login/checkcodereset.php'),
        body: {
          'id_buzz': id_buzz.toString(),
        });
    print(id_buzz);
    var res = jsonDecode(response.body);
    print(res['codereset']);
    if (res['codereset'] == _code) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
        Fluttertoast.showToast(
            msg: "opération réussie",
            toastLength: Toast.LENGTH_SHORT,
            fontSize: 12,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetScreen()));
      });
    } else {
      _isLoading = false;
      _isVerified = false;
      Fluttertoast.showToast(
          msg: "code incorrect réessayez",
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 12,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPass()));
    }
    //});
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex++;
        if (_currentIndex == 3) _currentIndex = 0;
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
          new TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Non'),
          ),
          new TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: new Text('Oui '),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: _onWillPop,
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
                        child: Stack(children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: AnimatedOpacity(
                              opacity: _currentIndex == 0 ? 1 : 0,
                              duration: Duration(
                                seconds: 1,
                              ),
                              curve: Curves.linear,
                              child: Image.asset('assets/intro_photo1.png',
                                  width: 80, height: 80),
                            ),
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
                              child: Image.asset('assets/intro_photo2.png',
                                  width: 100, height: 100),
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
                              child: Image.asset('assets/intro_photo3.png',
                                  width: 100, height: 100),
                            ),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInDown(
                          duration: Duration(milliseconds: 500),
                          child: Text(
                            "Verification",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff692062)),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInDown(
                        delay: Duration(milliseconds: 500),
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          "Veuillez entrer le code à 6 chiffres envoyé à\n ${secemail}${secphone}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                              height: 1.5),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // Verification Code Input
                      FadeInDown(
                        delay: Duration(milliseconds: 600),
                        duration: Duration(milliseconds: 500),
                        child: VerificationCode(
                          length: 6,
                          textStyle:
                          TextStyle(fontSize: 20, color: Colors.black),
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
                      SizedBox(
                        height: 20,
                      ),
                      FadeInDown(
                        delay: Duration(milliseconds: 700),
                        duration: Duration(milliseconds: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ne pas recevoir l'OTP?",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade500),
                            ),
                            TextButton(
                                onPressed: () {
                                  if (_isResendAgain) return;
                                  resend();
                                },
                                child: Text(
                                  _isResendAgain
                                      ? "Réessayez dans " + _start.toString()
                                      : "Renvoyer",
                                  style: TextStyle(color: Color(0xff692062)),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FadeInDown(
                        delay: Duration(milliseconds: 800),
                        duration: Duration(milliseconds: 500),
                        child: MaterialButton(
                          elevation: 0,
                          onPressed: () {
                            if (_code.length < 6) {
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => ResetScreen()));
                            } else {
                              verifySms();
                              //verify();
                            }
                          },
                          color: Color(0xff692062),
                          minWidth: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          child: _isLoading
                              ? Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                              : _isVerified
                              ? Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 30,
                          )
                              : Text(
                            "Vérifier",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )),
            )),
      ),
    );
  }
}
