import 'dart:math';
import 'package:assessment_task/welcome_screen.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'Widget/customClipper.dart';
import 'login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool signin = true;
  bool _isVisible = false;

  //Global Key for the form
  final GlobalKey<FormState> _keyreg = new GlobalKey<FormState>();

  // Controllers for TextFormFields
  late TextEditingController emailctrl,firstname,lnamectrl,companyctrl,phonectrl,passwordctrl,confpasswordctrl;
   String code="MA",code1="212";
  bool processing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailctrl = TextEditingController();
    firstname = TextEditingController();
    lnamectrl = TextEditingController();
    companyctrl = TextEditingController();
    phonectrl = TextEditingController();
    passwordctrl = TextEditingController();
    confpasswordctrl = TextEditingController();
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
  signupValid(){
    var formdata = _keyreg.currentState;
    if(formdata != null && !formdata.validate()){
      return "make sure all the fields are valide";
    }else if(formdata != null && formdata.validate()){
      registerUser();
    }
  }


  void registerUser() async{
    setState(() {
      processing = true;
    });
    var url = "https://okydigital.com/buzz_login/signup.php";
    var data = {
      "email":emailctrl.text,
      "first_name":firstname.text,
      "last_name":lnamectrl.text,
      "company":companyctrl.text,
      "phone": "+${code1},${code},${phonectrl.text.toString()}",
      "password":passwordctrl.text,
    };
    var res = await http.post(Uri.parse(url),body:data);
    print(jsonDecode(res.body).toString());
    if(jsonDecode(res.body) == "account already exists"){
      Fluttertoast.showToast(msg: "Compte existe, veuillez vous connecter".tr,toastLength: Toast.LENGTH_SHORT);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));

    }else if(jsonDecode(res.body) == "Created"){

      Fluttertoast.showToast(msg: "Compte créé".tr,toastLength: Toast.LENGTH_SHORT);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));

    }else{
      Fluttertoast.showToast(msg: "erreur".tr,toastLength: Toast.LENGTH_SHORT);
    }
    setState(() {
      processing = false;
    });
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Êtes-vous sûr'.tr),
        content: new Text('Voulez-vous quitter une application'.tr),
        actions: <Widget>[
          new TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Non'.tr),
          ),
          new TextButton(
            onPressed: () =>SystemNavigator.pop(),
            child: new Text('Oui'.tr),
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
                              height: 200,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text('Inscription'.tr,
                                style: TextStyle(fontSize: height*0.04,color: Color(0xff692062)),

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
                                      height: 10,
                                    ),
                                    TextFormField(
                                        controller: emailctrl,
                                        validator: (value) {
                                          Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                                          if (value == null || value.trim().isEmpty) {
                                            return 'Champ obligatoire'.tr;
                                          }
                                          else{
                                            RegExp regex =  RegExp(pattern.toString());
                                            if(!regex.hasMatch(value)){
                                              return 'Entrer une Adresse Email valide'.tr;
                                            }
                                          }
                                          return null;
                                        },
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: 'Adresse é-mail'.tr,
                                          fillColor: Color(0xfff3f3f4),
                                          filled: true,
                                        )
                                    ),//Email
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                        children:<Widget> [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              child:  TextFormField(
                                                  controller: firstname,
                                                  validator: (value) {
                                                    Pattern pattern = r"^\s*([A-Za-z]{1,}([\.,] |[-']|))\s*$";

                                                    if (value == null || value.trim().isEmpty) {
                                                      return 'Champ obligatoire'.tr;
                                                    }
                                                    else{
                                                      RegExp regex =  RegExp(pattern.toString());
                                                      if(!regex.hasMatch(value)){
                                                        return 'Entrer un prénom valide'.tr;
                                                      }
                                                    }
                                                    return null;
                                                  },
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText: 'Prénom'.tr,
                                                    fillColor: Color(0xfff3f3f4),
                                                    filled: true,
                                                  )
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child :TextFormField(
                                                  controller: lnamectrl,
                                                  validator: (value) {
                                                    Pattern pattern = r"^\s*([A-Za-z]{1,}([\.,] |[-']|))\s*$";

                                                    if (value == null || value.trim().isEmpty) {
                                                      return 'Champ obligatoire'.tr;
                                                    }
                                                    else{
                                                      RegExp regex =  RegExp(pattern.toString());
                                                      if(!regex.hasMatch(value)){
                                                        return 'Entrer un nom valide'.tr;
                                                      }
                                                    }
                                                    return null;
                                                  },
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    hintText: 'Nom'.tr,
                                                    fillColor: Color(0xfff3f3f4),
                                                    filled: true,
                                                  )
                                              ),
                                            ),
                                          ),
                                        ]
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        controller: companyctrl,
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty)
                                          { return 'Champ obligatoire'.tr;}
                                          return null;
                                        },
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: 'Société'.tr,
                                          fillColor: Color(0xfff3f3f4),
                                          filled: true,
                                        )
                                    ),//Company
                                    SizedBox(
                                      height: 10,
                                    ),
                                    IntlPhoneField(
                                      controller: phonectrl,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      invalidNumberMessage: 'Enter numéro de téléphone valide'.tr,
                                      searchText: 'Rechercher'.tr,
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null || value.toString().trim().isEmpty)
                                        { return 'Champ obligatoire'.tr;}
                                        return null;},
                                      decoration:  InputDecoration(
                                        hintText: 'Numéro de téléphone'.tr,
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
                                    ),//phone
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        controller: passwordctrl,
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty)
                                          { return 'Champ obligatoire'.tr;}
                                          else if(value.trim().length < 8)
                                          { return 'Ne peut pas être inférieur à 8 caractères'.tr;}
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
                                                  color: Color(0xff692062))
                                                  : Icon(Icons.visibility_off, color: Colors.black12),
                                            ),
                                            hintText: 'Mot de passe'.tr,
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true)
                                    ), //password
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        controller: confpasswordctrl,
                                        validator: (value){
                                          if (value == null || value.trim().isEmpty)
                                          { return 'Champ obligatoire'.tr;}
                                          if (value != passwordctrl.text)
                                          { return 'Veuillez entrer le même mot de passe'.tr;}
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
                                                  color: Color(0xff692062))
                                                  : Icon(Icons.visibility_off, color: Colors.black12),
                                            ),
                                            hintText: 'Confirmez mot de passe'.tr,
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true)
                                    ),
                                    SizedBox(
                                      height: 10,
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
                                  child: Text('Créer un compte'.tr, style: TextStyle(fontSize: 20, color: Colors.white),),
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
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
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