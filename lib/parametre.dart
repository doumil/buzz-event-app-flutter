import 'package:animate_do/animate_do.dart';
import 'package:assessment_task/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'editProfil_screen.dart';
import 'forgotPassEmail.dart';
import 'forgotPassPhone.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class ParametreScreen extends StatefulWidget {
  const ParametreScreen({Key? key}) : super(key: key);

  @override
  _ParametreScreenState createState() => _ParametreScreenState();
}

class _ParametreScreenState extends State<ParametreScreen> {
  final GlobalKey _menuKey = new GlobalKey();
  void initState() {
    super.initState();
  }
  _launchURL() async {
    const url = 'https://buzzevents.co/contact.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Paramétres"),
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
      body: Container(
        color: Color(0xfff7f2f7),
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.reset_tv),
              title: Text('réinitialiser le mot de passe'),
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
                              RaisedButton (
                                color: const Color(0xff692062),
                                shape:const RoundedRectangleBorder(
                                    side: BorderSide(width: 2,color: Color(0xff692062), ) ,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                                ) ,
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
                              RaisedButton (
                                color: Colors.white,
                                shape:const RoundedRectangleBorder(
                                    side: BorderSide(width: 2,color: Color(0xff692062), ) ,
                                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                                ) ,
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
              trailing: Container(
                margin: const EdgeInsets.only(right:12.0),
                child: Wrap(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                  ],
                ),
              ),
            ),
            new Divider(
              color: Color.fromRGBO(150, 150, 150, 0.4),
              height: 5.0,
            ),
            ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text('modifier le profil'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => EditProfilScreen()));
              },
              trailing:Container(
                margin: const EdgeInsets.only(right:8.0),
                child: Wrap(
                    children: <Widget>[
                      Icon(Icons.keyboard_arrow_right),
                          ]
                  ),
              ),// icon-1// icon-2
            ),
            new Divider(
              color: Color.fromRGBO(150, 150, 150, 0.4),
              height: 5.0,
            ),
            ListTile(
              leading: Icon(Icons.contact_phone_outlined),
              title: Text('contactez nous'),
              onTap: () {
                _launchURL();
              },
              trailing: Container(
                margin: const EdgeInsets.only(right:13.0),
                child: Wrap(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
