import 'dart:math';
import 'package:assessment_task/Widget/customClipper.dart';
import 'package:assessment_task/home_screen.dart';
import 'package:assessment_task/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
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
                height:300,
                child: Container(
                  child:  Center(
                    child: Container(
                      child: const Center(child: Image(image: AssetImage("assets/profil.jpg"),width: 150, alignment: Alignment.center,)),
                    ),
                  ) ,
                ),
              ),
            ],
          ),
        ));
  }
}
