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


class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  bool signin = true;
  bool _isVisible = false;
  late var id,email,fname,lname,company,phone;
  //Global Key for the form
  final GlobalKey<FormState> _keyreg = new GlobalKey<FormState>();
  // Controllers for TextFormFields
  late TextEditingController companyctrl;
  bool processing = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
    companyctrl = TextEditingController();
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
      companyctrl.text= company;
    });
  }
  void changePhone() async{
    setState(() {
      processing = true;
    });
    //here update company
    var response = await http.post(Uri.parse('https://okydigital.com/buzz_login/updateprofile.php'),body:{
      'id_buzz':id.toString(),
      'fname':fname.toString(),
      'lname':lname.toString(),
      'company':companyctrl.text.toString(),
      'phone':phone.toString()
    });
    var res = jsonDecode(response.body);
    if(res=="Updated") {
      SharedPreferences sessionLogin = await SharedPreferences.getInstance();
      sessionLogin.setString("company",companyctrl.text.toString());
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
                                      TextFormField(
                                          controller: companyctrl,
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty)
                                            { return 'Champ obligatoire';}
                                            return null;
                                          },
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'Société',
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true,
                                          )
                                      ),//Company
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