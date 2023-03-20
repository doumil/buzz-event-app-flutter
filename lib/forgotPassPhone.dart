import 'dart:math';
import 'package:assessment_task/submitcode_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widget/customClipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class ForgotPassPhone extends StatefulWidget {
  const ForgotPassPhone({Key? key}) : super(key: key);

  @override
  _ForgotPassPhoneState createState() => _ForgotPassPhoneState();
}

class _ForgotPassPhoneState extends State<ForgotPassPhone> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checklogin();
  }
  var  code="MA",code1="212";
  TextEditingController phonectrl = TextEditingController();
  var codeRandom = Random();
  bool processing = false;
  bool disable=true;
  GlobalKey<FormState> _keyforg = new GlobalKey<FormState>();
  //bool verifyButton = false;
  //late String verifyLnk;
  int codeReset=0;
  int min=100000,max=999999;
  String resphone="";
  checklogin () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone = prefs.getString('phone');
    var ss = phone?.split(",");
    List<String> list1 = [];
    ss?.forEach((e) {
      list1.add(e);
    });
    var phoneSp="${list1.elementAt(2)}";
    var id=prefs.getInt('id');
    if (phoneSp!=null||id!=null)
    {
      setState(() {
        phonectrl.text=phoneSp.toString();
        disable=false;
      });

    }
  }
  saveInfo(int id_buzz,String phone) async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    sessionLogin.setInt("id_buzz", id_buzz);
    sessionLogin.setString("phoneRP",phone);
    sessionLogin.setString("emailRP","");
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
     resphone="+${code1}${phonectrl.text.toString()}";
     print("---------*${resphone}*---------");
    setState(() {
      processing = true;
    });
    codeReset= min+codeRandom.nextInt(max - min);
     await FirebaseAuth.instance.verifyPhoneNumber(
       phoneNumber: resphone,
       timeout: Duration(seconds: 60),
       verificationCompleted: (PhoneAuthCredential credential) {

       },
       verificationFailed: (FirebaseAuthException e) {
         print("----------------");
         print(e);
         print("----------------");
             Fluttertoast.showToast(msg: "vous avez envoyé plusieurs SMS de vérification ,réessayer plus tard",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.black, textColor: Colors.white,timeInSecForIosWeb:60,);
       },
       codeSent: (String verificationId, int? resendToken) async{
         print("----------------code has sent ${verificationId}");
         var response = await http.post(Uri.parse('https://okydigital.com/buzz_login/checkphone.php'),body:{
           'phone': "+${code1},${code},${phonectrl.text.toString()}",
           'codeReset':verificationId
         });
         var res = jsonDecode(response.body);
         if(res['status']=="InvalidPhone"){
           Fluttertoast.showToast(msg: "Cet numéro de télèphone est incorrect",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white);
         }else{
           //generate code :
           print(codeReset);
           print(int.parse(res['id']));
           //save code to shared preference
           saveInfo(int.parse(res['id']),res['phone']);
           Fluttertoast.showToast(msg: "Vérifiez votre sms",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.black, textColor: Colors.white);
           Navigator.push(context, MaterialPageRoute(builder: (context) => Verificatoin()));
         }
         setState(() {
           processing = false;
         });
       },
       codeAutoRetrievalTimeout: (String verificationId) {
       },
     );
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
              height: height,
              child: SingleChildScrollView(
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
                                        IntlPhoneField(
                                          enabled: disable,
                                          controller: phonectrl,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          invalidNumberMessage: ' Enter numéro de téléphone valide',
                                          searchText: 'Rechercher',
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value == null || value.toString().trim().isEmpty)
                                            { return 'Champ obligatoire';}
                                            return null;},
                                          decoration: const InputDecoration(
                                            hintText: 'Numéro de téléphone',
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true,
                                          ),
                                          initialCountryCode:code.toString(),
                                          onCountryChanged: (phone) {
                                            //print(phone.completeNumber);
                                            setState(() {
                                              code=phone.code;
                                              code1=phone.dialCode;
                                            });
                                          },
                                        ),
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
                                child: processing == false
                                    ?Container(
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
                                )
                                    : CircularProgressIndicator(
                                  color: Colors.white,
                                  backgroundColor: Color(0xff692062),
                                )
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
          )),
    );
  }
  showToast(String msg, {required int duration, required int gravity}){

    showToast(msg, duration: duration, gravity: gravity);

  }
}

