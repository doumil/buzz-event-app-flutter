import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:assessment_task/profil_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class NameScreen extends StatefulWidget {
  const NameScreen({Key? key}) : super(key: key);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  bool signin = true;
  bool _isVisible = false;
  late var id,email,fname,lname,company,phone;
  //Global Key for the form
  final GlobalKey<FormState> _keyreg = new GlobalKey<FormState>();
  // Controllers for TextFormFields
  late TextEditingController fnamectrl,lnamectrl;
  bool processing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
    fnamectrl = TextEditingController();
    lnamectrl = TextEditingController();

  }
  //form != null && !form.validate()
  signupValid(){
    var formdata = _keyreg.currentState;
    if(formdata != null && !formdata.validate()){
      return "make sure all the fields are valide";
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
    phone   = sessionLogin.getString("phone");
    setState(() {
      fnamectrl.text= fname;
      lnamectrl.text=lname;
    });
  }
  void changePhone() async{
    setState(() {
      processing = true;
    });
    //here update company
    var response = await http.post(Uri.parse('https://okydigital.com/buzz_login/updateprofile.php'),body:{
      'id_buzz':id.toString(),
      'fname':fnamectrl.text.toString(),
      'lname':lnamectrl.text.toString(),
      'company':company.toString(),
      'phone':phone.toString()
    });
    var res = jsonDecode(response.body);
    if(res=="Updated") {
      SharedPreferences sessionLogin = await SharedPreferences.getInstance();
      sessionLogin.setString("fname",fnamectrl.text.toString());
      sessionLogin.setString("lname",lnamectrl.text.toString());
      Fluttertoast.showToast(msg: "company a été changé avec succès",toastLength: Toast.LENGTH_SHORT, fontSize: 12, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white);
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
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Edit profile ${fname} ${lname}"),
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
                            height: 120,
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
                                                controller: fnamectrl,
                                                validator: (value) {
                                                  Pattern pattern = r"^\s*([A-Za-z]{1,}([\.,] |[-']|))\s*$";

                                                  if (value == null || value.trim().isEmpty) {
                                                    return 'Champ obligatoire';
                                                  }
                                                  else{
                                                    RegExp regex =  RegExp(pattern.toString());
                                                    if(!regex.hasMatch(value)){
                                                      return 'Entrer un prénom valide';
                                                    }
                                                  }
                                                  return null;
                                                },
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText: 'Prénom',
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
                                                    return 'Champ obligatoire';
                                                  }
                                                  else{
                                                    RegExp regex =  RegExp(pattern.toString());
                                                    if(!regex.hasMatch(value)){
                                                      return 'Entrer un nom valide';
                                                    }
                                                  }
                                                  return null;
                                                },
                                                obscureText: false,
                                                decoration: InputDecoration(
                                                  hintText: 'Nom',
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true,
                                                )
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                  SizedBox(
                                    height: 14,
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
                                child: Text('changer', style: TextStyle(fontSize: 20, color: Colors.white),),
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