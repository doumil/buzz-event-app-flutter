import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:assessment_task/profil_screen.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class EditProfilScreen extends StatefulWidget {
  const EditProfilScreen({Key? key}) : super(key: key);

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  late var code="MA",code1="212",phonewithcode="",lang="";
  bool signin = true;
  bool _isVisible = false;
  late var id,email,fname,lname,company,phone;
  //Global Key for the form
  final GlobalKey<FormState> _keyreg = new GlobalKey<FormState>();
  // Controllers for TextFormFields
  late TextEditingController companyctrl,firstnamectrl,lnamectrl,phonectrl,passwordctrl,confpasswordctrl,emailctrl;
  bool processing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
    firstnamectrl = TextEditingController();
    emailctrl=TextEditingController();
    lnamectrl = TextEditingController();
    companyctrl = TextEditingController();
    phonectrl = TextEditingController();


  }
  void loadLang() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang =prefs.getString("lang")!;
    print(lang);
  }
  //form != null && !form.validate()
  signupValid(){
    var formdata = _keyreg.currentState;
    if(formdata != null && !formdata.validate()){
      return "assurez-vous que tous les champs sont valides".tr;
    }else if(formdata != null && formdata.validate()){
      changePhone();
    }
  }
  _loadData() async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    id      = sessionLogin.getInt("id");
    email   = sessionLogin.getString("email");
    fname   = sessionLogin.getString("fname");
    lname   = sessionLogin.getString("lname");
    company = sessionLogin.getString("company");
    phonewithcode = sessionLogin.getString("phone").toString();
    var ss = phonewithcode.split(",");
    List<String> list1 = [];
    ss.forEach((e) {
      list1.add(e);
    });
    phone="${list1.elementAt(2)}";
    code="${list1.elementAt(1)}";
    setState(() {
      firstnamectrl.text=fname;
      lnamectrl.text=lname;
      emailctrl.text=email;
      companyctrl.text=company;
      phonectrl.text = phone;

    });
  }
  void changePhone() async{
    setState(() {
      processing = true;
    });
    //here update company
    var response = await http.post(Uri.parse('https://okydigital.com/buzz_login/updateprofile.php'),body:{
      'id_buzz':id.toString(),
      'fname':firstnamectrl.text.toString(),
      'lname':lnamectrl.text.toString(),
      'company':companyctrl.text.toString(),
      'phone': "+${code1},${code},${phonectrl.text.toString()}"
    });
    var res = jsonDecode(response.body);
    if(res=="Updated") {
      SharedPreferences sessionLogin = await SharedPreferences.getInstance();
      sessionLogin.setString("fname","${firstnamectrl.text.toString()}");
      sessionLogin.setString("lname","${lnamectrl.text.toString()}");
      sessionLogin.setString("company",companyctrl.text.toString());
      sessionLogin.setString("phone","+${code1},${code},${phonectrl.text.toString()}");
      Fluttertoast.showToast(msg: "Profil a été changé avec succès".tr,toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.black, textColor: Colors.white);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }

    setState(() {
      processing = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          /* leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          */
          title: Text("".tr +
              " ${fname} ${lname}"),
          actions: <Widget>[],
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color.fromRGBO(103, 33, 96, 1.0), Colors.black])),
          ),
        ),
        body: FadeInRight(
          duration: Duration(milliseconds: 500),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        child: Image(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 3,
                          fit: BoxFit.cover,
                          image: AssetImage("assets/background-buz2.png"),
                        ),
                      ),
                      Positioned(
                          bottom: -50.0,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Color(0xff692062),
                            child: CircleAvatar(
                                radius: 75,
                                backgroundImage: AssetImage("assets/profil.jpg")
                            ),
                          ))
                    ]),
                Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 90,
                          ),
                          Form(
                            key: _keyreg,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                      children:<Widget> [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child:  TextFormField(
                                                controller: firstnamectrl,
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
                                    enabled: false,
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
                                    decoration: const InputDecoration(
                                      hintText: "Numero de telephone",
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
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
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
                                child: Text('sauvegarder'.tr, style: TextStyle(fontSize: 20, color: Colors.white),),
                              ) : CircularProgressIndicator(color: Colors.white,backgroundColor: Color(0xff692062),)
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}