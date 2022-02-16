import 'dart:math';

import 'package:assessment_task/Widget/customClipper.dart';
import 'package:assessment_task/home_screen.dart';
import 'package:assessment_task/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    double width =MediaQuery.of(context).size.width;
   return Scaffold(
       extendBodyBehindAppBar: true,
     appBar: AppBar(
       backgroundColor: Colors.transparent,
       elevation: 0,
     ),
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
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
                      Container(
                        alignment: Alignment.topCenter,
                        height:300,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(image:
                            AssetImage("assets/background-buz2.png"),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          child:  Center(
                            child: Container(
                              child: const Center(child: Image(image: AssetImage("assets/logo.png"),width: 60, alignment: Alignment.center,)),
                            ),
                          ) ,
                        ),
                      ),
                      //SizedBox(height: height * .2),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text('Sign up',
                          style: TextStyle(fontSize: height*0.04,color: Color(0xff692062)),

                        ),
                      ),
                      //SizedBox(height: 50),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
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
                                     child:  TextField(
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            hintText: 'First name',
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true,
                                          )
                                      ),
                                    width: width*0.35,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                  child :TextField(
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Last name',
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      )
                                  ),
                                    width: width*0.35,
                                  ),
                                ),
                               ]
                            ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Company',
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                    )
                                ),//Company
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      hintText: 'Phone',
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true,
                                    )
                                ),//phone
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: 'Password',
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true)
                                ),//password
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: 'Confirmation',
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true)
                                )//Confirmation password
                              ],
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        ),
                        child: Container(
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
                          child: Text(
                            'Create account',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .055),
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
        ));
  }
}
