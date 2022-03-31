import 'package:assessment_task/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'forgotPass.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class ParametreScreen extends StatefulWidget {
  const ParametreScreen({Key? key}) : super(key: key);

  @override
  _ParametreScreenState createState() => _ParametreScreenState();
}

class _ParametreScreenState extends State<ParametreScreen> {
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
              trailing: Wrap(
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                ],
              ),
            ),
            new Divider(
              color: Color.fromRGBO(150, 150, 150, 0.4),
              height: 5.0,
            ),
            ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text('Editer le profil'),
              onTap: () {
              },
              trailing: Wrap(
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                ],
              ),
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
              trailing: Wrap(
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                ],
              ),
            ),
            PopupMenuButton<WhyFarther>(
              onSelected: (WhyFarther result) { setState(() {}); },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.harder,
                  child: Text('Working a lot harder'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.smarter,
                  child: Text('Being a lot smarter'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.selfStarter,
                  child: Text('Being a self-starter'),
                ),
                const PopupMenuItem<WhyFarther>(
                  value: WhyFarther.tradingCharter,
                  child: Text('Placed in charge of trading charter'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
