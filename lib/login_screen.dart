import 'dart:math';
import 'package:assessment_task/Widget/customClipper.dart';
import 'package:assessment_task/home_screen.dart';
import 'package:assessment_task/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
        body: Container(
      height: height,
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
                  child: const Center(child: Image(image: AssetImage("assets/logo.png"),width: 60, alignment: Alignment.center,)),
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
                    child: Text('Sign in',
                      style: TextStyle(fontSize: height*0.04,color: Color(0xff692062)),

                    ),
                  ),

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
                            TextField(
                                obscureText: true,
                                decoration: InputDecoration(

                                  hintText: 'Password',
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true)
                            )
                          ],
                        ),
                      )
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
                        'Login',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?',
                        style: TextStyle(color: Color(0xff682062),
                            fontSize: 14, fontWeight: FontWeight.w500),

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
                            'Don\'t have an account ?',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Register',
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
    ));
  }
}
