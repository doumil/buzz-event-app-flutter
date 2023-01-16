import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:assessment_task/welcome_screen.dart';
import 'package:flutter/services.dart';
import 'forgotPassEmail.dart';
import 'Widget/customClipper.dart';
import 'forgotPassPhone.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool signin = true;
  //For showing password
  bool _isVisible = false;
  // Global key for the form
  GlobalKey<FormState> _keylog = new GlobalKey<FormState>();
  // Controllers for TextFormFields
  late TextEditingController emailctrl, passwordctrl;
  //Pattern for email validation
  bool processing = false;
  //session login
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailctrl = TextEditingController();
    passwordctrl = TextEditingController();
  }
  void changeState() {
    if (signin) {
      setState(() {
        signin = false;
      });
    } else {
      setState(() {
        signin = true;
      });
    }
  }

//form != null && !form.validate()
  signinValid() {
    var formdata = _keylog.currentState;
    if (formdata != null && !formdata.validate()) {
      return "make sure all the fields are valide";
    } else
      return userSignIn();
  }

  void userSignIn() async {
    setState(() {
      processing = true;
    });
    var url = "https://okydigital.com/buzz_login/login1.php";
    var data = {
      "email": emailctrl.text.trim().toString(),
      "password": passwordctrl.text.toString(),
    };

    var res = await http.post(Uri.parse(url), body: data);
    //String jsonsDataString = res.body.toString();
    var resbody = await jsonDecode(res.body);
    if (resbody['status'] == "Error") {
      Fluttertoast.showToast(
          msg: "vous n\'avez pas de compte, créez un compte",
          toastLength: Toast.LENGTH_SHORT);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    }
    else if (resbody['status']== "Success") {

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
    else if (resbody['status'] == "incorrectpass")
      {
        Fluttertoast.showToast(
            msg: "Mot de passe est incorrect", toastLength: Toast.LENGTH_SHORT);
        passwordctrl.text="";
      }
    setState(() {
      processing = false;
    });
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
            onPressed: () =>SystemNavigator.pop(),
            child: new Text('Oui'),
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
                        height: 200,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/background-buz2.png"),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              child: const Center(
                                  child: Image(
                                image: AssetImage("assets/logobuzzeventsf.png"),
                                width: 230,
                                alignment: Alignment.center,
                              )),
                            ),
                          ),
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
                                child: Text(
                                  'Connexion',
                                  style: TextStyle(
                                      fontSize: height * 0.04,
                                      color: Color(0xff692062)),
                                ),
                              ),
                              Form(
                                key: _keylog,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              controller: emailctrl,
                                              validator: (value) {
                                                Pattern pattern =
                                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Champ obligatoire';
                                                } else {
                                                  RegExp regex =
                                                      RegExp(pattern.toString());
                                                  if (!regex.hasMatch(value)) {
                                                    return 'Entrer une Adresse Email valide';
                                                  }
                                                }
                                                return null;
                                              },
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                hintText: 'Adresse e-mail',
                                                fillColor: Color(0xfff3f3f4),
                                                filled: true,
                                              ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              controller: passwordctrl,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return 'Champ obligatoire';
                                                } else if (value.trim().length <
                                                    8) {
                                                  return 'Ne peut pas être inférieur à 8 caractères';
                                                }
                                                return null;
                                              },
                                              obscureText: !_isVisible,
                                              decoration: InputDecoration(
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isVisible = !_isVisible;
                                                      });
                                                    },
                                                    icon: _isVisible
                                                        ? Icon(Icons.visibility,
                                                            color:  Color(0xff692062))
                                                        : Icon(Icons.visibility_off,
                                                            color: Colors.black12),
                                                  ),
                                                  hintText: 'Mot de passe',
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              MaterialButton(
                                  onPressed: () {
                                    signinValid();
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                                  },
                                  child: processing == false
                                      ? Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding:
                                              EdgeInsets.symmetric(vertical: 15),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Colors.grey.shade200,
                                                  offset: Offset(2, 4),
                                                  blurRadius: 5,
                                                  spreadRadius: 2)
                                            ],
                                            color: Color(0xff692062),
                                          ),
                                          child: Text(
                                            'Se connecter',
                                            style: TextStyle(
                                                fontSize: 20, color: Colors.white),
                                          ),
                                        )
                                      : CircularProgressIndicator(
                                          color: Colors.white,
                                          backgroundColor: Color(0xff692062),
                                        )),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) => FadeInUp(
                                        duration: Duration(milliseconds: 500),
                                        child: AlertDialog(
                                          title: Center(child: const Text('Veuillez choisir comment vous souhaitez réinitialiser votre mot de passe',style: TextStyle(color: Color(0xff803b7a),fontSize:17,fontWeight: FontWeight.bold))),
                                          content:   Container(
                                                 height: 120,
                                                 width: 120,
                                            child: ListView(
                                                padding: EdgeInsets.all(0),
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      shape:const RoundedRectangleBorder(
                                                          side: BorderSide(width: 2,color: Color(0xff692062), ) ,
                                                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                      ) ,
                                                      primary: Color(0xff692062),
                                                    ),
                                                   // color: const Color(0xff692062),
                                                    onPressed: ()  {
                                                      Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => ForgotPassPhone()));
                                                    },
                                                    child: const Text ( ('Par téléphone') ,style: TextStyle(fontSize:20,color: Colors.white,fontWeight: FontWeight.w300),
                                                    ) ,
                                                  ),
                                                  SizedBox(
                                                    height: 14,
                                                  ),
                                                  ElevatedButton (
                                                    style: ElevatedButton.styleFrom(
                                                      shape:const RoundedRectangleBorder(
                                                          side: BorderSide(width: 2,color: Color(0xff692062), ) ,
                                                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                                                      ) ,
                                                      primary: Colors.white,
                                                    ),
                                                   // color: Colors.white,
                                                    onPressed: ()  {
                                                      Navigator.push(
                                                          context, MaterialPageRoute(builder: (context) => ForgotPassEmail()));
                                                    },
                                                    child: const Text ( ('Par Email') ,style: TextStyle(fontSize:20,color: Color(0xff692062),fontWeight: FontWeight.w300),
                                                    ) ,
                                                  ),

                                                ]
                                            ),
                                               ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'Annuler'),
                                              child: Center(child: const Text('Cancel',style: TextStyle(color: Color(0xff803b7a),fontWeight: FontWeight.bold))),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Mot de passe oublié ?',
                                    style: TextStyle(
                                        color: Color(0xff682062),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpScreen()));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  padding: EdgeInsets.all(15),
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Vous n\'avez pas de compte ?',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'S\'inscrire',
                                        style: TextStyle(
                                            color: Color(0xff682062),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
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
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 0, top: 10, bottom: 10),
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
                ))),
      ),
    );
  }
}
