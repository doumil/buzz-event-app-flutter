import 'dart:math';
import 'forgotPass.dart';
import 'Widget/customClipper.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
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
  late TextEditingController emailctrl,passwordctrl;

  //Pattern for email validation


  bool processing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailctrl = TextEditingController();
    passwordctrl = TextEditingController();

  }

  void changeState(){
    if(signin){
      setState(() {
        signin = false;

      });
    }else {
      setState(() {
        signin = true;

      });
    }
  }

//form != null && !form.validate()
  signinValid(){
    var formdata = _keylog.currentState;
    if(formdata != null && !formdata.validate()){
      return "make sure all the fields are valide";
    }else
      return userSignIn();
  }



  void userSignIn() async{
    setState(() {
      processing = true;
    });
    var url = "http://192.168.1.179/buzz_login/login.php";
    var data = {
      "email":emailctrl.text.trim(),
      "password":passwordctrl.text,
    };
    print("hello");
    var res = await http.post(Uri.parse(url),body:data);
     print("by");
    if(jsonDecode(res.body) == "Error"){
      Fluttertoast.showToast(msg: "vous n\'avez pas de compte, créez un compte",toastLength: Toast.LENGTH_SHORT);
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
    }
    else if(jsonDecode(res.body) == "Success")
    {
      Fluttertoast.showToast(msg: "Connecté avec succès",toastLength: Toast.LENGTH_SHORT);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));

    }
    else {
      if(jsonDecode(res.body) == "incorrectpass"){
        print(jsonDecode(res.body));
        Fluttertoast.showToast(msg: "Mot de passe est incorrect",toastLength: Toast.LENGTH_SHORT);}

    }


    setState(() {
      processing = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                        child: Text('Connexion',
                          style: TextStyle(fontSize: height*0.04,color: Color(0xff692062)),

                        ),
                      ),

                      Form(
                        key: _keylog,
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
                                        hintText: 'Adresse e-mail',
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
                                            icon: _isVisible ? Icon(Icons.visibility, color: Colors.deepPurple) : Icon(Icons.visibility_off, color: Colors.black12),
                                          ),
                                          hintText: 'Mot de passe',
                                          fillColor: Color(0xfff3f3f4),
                                          filled: true)
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      MaterialButton(
                          onPressed:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                          },
                          //signinValid(),
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
                            child: Text('Se connecter', style: TextStyle(fontSize: 20, color: Colors.white),),
                          ) : CircularProgressIndicator(color: Colors.white,backgroundColor: Color(0xff692062),)
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child:
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPass()));
                          },
                          child: Text('Mot de passe oublié ?',
                            style: TextStyle(color: Color(0xff682062),
                                fontSize: 14, fontWeight: FontWeight.w500),

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
                                    fontSize: 13, fontWeight: FontWeight.w600),
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
    );
  }
}