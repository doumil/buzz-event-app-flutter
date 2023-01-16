import 'package:assessment_task/parametre.dart';
import 'package:assessment_task/qr_screen.dart';
import 'package:assessment_task/utils/database_helper.dart';
import 'package:assessment_task/welcome_screen.dart';
import 'package:assessment_task/profil_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_task/profils_enregistrés.dart';
import 'package:assessment_task/détails_screen.dart';
import 'package:assessment_task/brouillon_screen.dart';
import 'package:assessment_task/synchron_screen.dart';
import 'model/user_scanner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var response;
  var updated="";
  var db = new DatabaseHelper();
  String _data = "";
  List<String> litems = [];
  Userscan user1 = Userscan('','','','','','','','','','','');
  late SharedPreferences prefs;
  _scan(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => QrcodeScreen()));
  }
  _scan1() async {
    int _count=0;
    await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Annuler", true, ScanMode.QR)
        .then((value) => setState(() => _data = value));
    prefs = await SharedPreferences.getInstance();
    prefs.setString("Data", _data);
    if (_data != '-1') {
      var ss = _data.split(";");
      List<String> list1 = [];
      ss.forEach((e) {
        list1.add(e);
        _count++;
      });
      print(_count);
      print(_data);
      if (_count == 6) {
        print(_count);
        //Userscan user1=Userscan('khalid','fayzi','ok solution','faw@gmail.com','068798738','hay hassani casablanca','Evo','Act','Not');
        user1 = Userscan(
            list1.elementAt(0),
            list1.elementAt(1),
            list1.elementAt(2),
            list1.elementAt(3),
            list1.elementAt(4),
            list1.elementAt(5),
            '',
            '',
            '',
            '',
            '');
        response = await db.getUsersByemail(user1.email.toString());
        print("------------------------------");
        print(response);
        print("------------------------------");
        if (response.toString() == "[]") {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailsScreen()));
        }
        else if (response.toString() != "[]") {
          user1.evolution = response[0]["evolution"];
          user1.action = response[0]["action"];
          user1.notes = response[0]["notes"];
          user1.created = response[0]["created"];
          user1.updated = "${DateTime
              .now()
              .day}/${DateTime
              .now()
              .month}/${DateTime
              .now()
              .year} ${DateTime
              .now()
              .hour}:${DateTime
              .now()
              .minute}";
          db.updateUser(user1, user1.email);
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => profilsEnregistresScreen()));
        }
      }
      else{
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('erreur'),
            content: const Text(
                'QR code invalid'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child:
                const Text('OK', style: TextStyle(color: Color(0xff803b7a))),
              ),
            ],
          ),
        );
      }
    }else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('erreur'),
          content: const Text(
              'La devise n\'a pas été complétée avec succès. Veuillez réessayer'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child:
                  const Text('OK', style: TextStyle(color: Color(0xff803b7a))),
            ),
          ],
        ),
      );
    }
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Êtes-vous sûr'),
        content: new Text('Voulez-vous quitter une application'),
        actions: <Widget>[
          new TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Non'),
          ),
          new TextButton(
            onPressed: () =>SystemNavigator.pop(),
            child: new Text('Oui '),
          ),
        ],
      ),
    )) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:_onWillPop,
      child: Scaffold(
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BrouillonScreen()));
                  },
                  trailing: Wrap(
                    children: <Widget>[
                      Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.sync),
                  title: Text('Synchroniser'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SynchronScreen()));
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
                  title: Text('Mon profile'),
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ParametreScreen()));
                  },
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
                    SharedPreferences sessionLogin =
                        await SharedPreferences.getInstance();
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
                                text: "bienvenue !",
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
                    Text("Vous pouvez scanner maintenant",
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
      ),
    );
  }
}
