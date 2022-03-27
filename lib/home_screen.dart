import 'package:assessment_task/welcome_screen.dart';
import 'package:assessment_task/Profil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_task/profils_enregistrés.dart';
import 'package:assessment_task/détails_screen.dart';
import 'package:assessment_task/brouillon_screen.dart';
import 'package:assessment_task/syncrohn_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String _data = "";
  late SharedPreferences prefs;
  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Annuler", true, ScanMode.QR)
        .then((value) => setState(() => _data = value));
    prefs = await SharedPreferences.getInstance();
    prefs.setString("Data", _data);
    if (_data != '-1') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DetailsScreen()));
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('erreur'),
          content: const Text('La devise n\'a pas été complétée avec succès. Veuillez réessayer'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK',style: TextStyle(color: Color(0xff803b7a))),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: <Widget>[],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer:
          //drawer
          new Drawer(
        elevation: 0,
        child: Container(
          color: Color(0xfff7f2f7),
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/back.png.png"),
                        fit: BoxFit.cover,
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(103, 33, 96, 1.0),
                            Colors.black
                          ])),
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset(
                    "assets/logo15.png",
                  )),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Profils Enregistrés'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => profilsEnregistresScreen()));
                },
                trailing: Wrap(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.drafts),
                title: Text('Profils en brouillon'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BrouillonScreen()));
                },
                trailing: Wrap(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.sync),
                title: Text('Syncrohniser'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => syncrohnScreen()));
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
                leading: Icon(Icons.person),
                title: Text('Mon profil'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                trailing: Wrap(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Paramétres'),
                onTap: () {},
                trailing: Wrap(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Deconnexion'),
                onTap: () async {
                  SharedPreferences sessionLogin = await SharedPreferences.getInstance();
                  sessionLogin.remove("id");
                  sessionLogin.remove("email");
                  sessionLogin.remove("fname");
                  sessionLogin.remove("lname");
                  sessionLogin.remove("company");
                  sessionLogin.remove("phone");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
                trailing: Wrap(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(120),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.asset(
                      "assets/background-buz2.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(80),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: "bienvenu !",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 38,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Vous pouvez scannez maintenant",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff682062),
                        fontFamily: "Poppins",
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.height * 0.1,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(103, 33, 96, 1.0),
                                  Colors.yellow.shade100,
                                ],
                              ),
                            ),
                            child: IconButton(
                              hoverColor: Color.fromRGBO(103, 33, 96, 1.0),
                              onPressed: () async {
                                _scan();
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.height * 0.05,
                              ),
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
