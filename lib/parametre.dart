import 'package:assessment_task/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'editprofile/company_screen.dart';
import 'editprofile/name_screen.dart';
import 'editprofile/phone_screen.dart';
import 'forgotPass.dart';

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPass()));
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
                dynamic popUpMenustate = _menuKey.currentState;
                popUpMenustate.showButtonMenu();
              },
              trailing:Container(
                margin: const EdgeInsets.only(right:0.0),
                child: Wrap(
                    children: <Widget>[
                PopupMenuButton(
                      // add icon, by default "3 dot" icon
                       icon: Icon(Icons.keyboard_arrow_right),
                        key: _menuKey,
                        itemBuilder: (context){
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Text("modifier le nom et le prénom"),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Text("modifier l'entreprise"),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Text("modifier le téléphone"),
                            ),
                          ];
                        },
                        onSelected:(value){
                          if(value == 0){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => NameScreen()));
                          }else if(value == 1){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => CompanyScreen()));
                          }else if(value == 2){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => PhoneScreen()));
                          }
                        }
                    ),
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
