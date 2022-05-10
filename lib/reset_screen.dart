import 'dart:math';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widget/customClipper.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  //bool signin = true;
  bool _isVisible = false;
  late var id_buzz;
  //Global Key for the form
  final GlobalKey<FormState> _keyreg = new GlobalKey<FormState>();

  // Controllers for TextFormFields
  late TextEditingController passwordctrl,confpasswordctrl;
  bool processing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCodereset();
    passwordctrl = TextEditingController();
    confpasswordctrl = TextEditingController();
  }
  void changeState(){

    }
  //form != null && !form.validate()
  signupValid(){
    var formdata = _keyreg.currentState;
    if(formdata != null && !formdata.validate()){
      return "make sure all the fields are valide";
    }else if(formdata != null && formdata.validate()){
      resetpassword();
    }

  }
  getCodereset() async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    id_buzz = sessionLogin.getInt("id_buzz");
  }
  resetpassword() async{
    processing=true;
    var response = await http.post(Uri.parse('https://okydigital.com/buzz_login/resetpassword.php'),body:{
      'id_buzz':id_buzz.toString(),
      'newpassowrd':passwordctrl.text.toString()
    });
    var res = jsonDecode(response.body);
    if(res=="Updated") {
      setState(() {
        processing=false;
        Fluttertoast.showToast(msg: "le mot de passe a été changé avec succès",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.black, textColor: Colors.white);
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      });
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
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop:_onWillPop,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 220,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text('réinitialiser le mot de passe',
                                style: TextStyle(fontSize: height*0.03,fontWeight: FontWeight.bold,color: Color(0xff692062)),

                              ),
                            ),
                            Form(
                              key: _keyreg,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50,
                                    ),
                                    TextFormField(
                                        controller: passwordctrl,
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty)
                                          { return 'Champ obligatoire';}
                                          else if(value.trim().length < 8)
                                          { return 'Ne peut pas être inférieur à 8 caractères';}
                                          return null;
                                        },
                                        obscureText: !_isVisible,
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              onPressed: (){
                                                setState(() {
                                                  _isVisible = !_isVisible;
                                                });
                                              },
                                              icon: _isVisible ? Icon(Icons.visibility,
                                                  color:  Color(0xff692062)) :
                                              Icon(Icons.visibility_off, color: Colors.black12),
                                            ),
                                            hintText: 'Mot de passe',
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true)
                                    ), //password
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                        controller: confpasswordctrl,
                                        validator: (value){
                                          if (value == null || value.trim().isEmpty)
                                          { return 'Champ obligatoire';}
                                          if (value != passwordctrl.text)
                                          { return 'Veuillez entrer le même mot de passe';}
                                          return null;

                                        },
                                        obscureText: !_isVisible,
                                        decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              onPressed: (){
                                                setState(() {
                                                  _isVisible = !_isVisible;
                                                });
                                              },
                                              icon: _isVisible ? Icon(Icons.visibility,
                                                  color:  Color(0xff692062))
                                                  : Icon(Icons.visibility_off,
                                                  color: Colors.black12),
                                            ),
                                            hintText: 'Confirmez mot de passe',
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true)
                                    ),
                                    SizedBox(
                                      height: 100,
                                    )//Confirmation password
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            MaterialButton(
                                onPressed:() => signupValid(),
                                child: processing == false ? Container(
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
                                  child: Text('réinitialiser', style: TextStyle(fontSize: 20, color: Colors.white),),
                                ) : CircularProgressIndicator(color: Colors.white,backgroundColor: Color(0xff692062),)
                            ),
                            SizedBox(
                              height: 10,
                            ),                    ],
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
            )
        ),
      ),
    );
  }
}