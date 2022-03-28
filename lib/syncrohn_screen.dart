import 'dart:convert';

import 'package:assessment_task/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_task/model/user_scanner.dart';
import 'package:assessment_task/utils/database_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:assessment_task/profils_enregistrés.dart';
import 'package:http/http.dart' as http;

late SharedPreferences pr;
List<Userscan> litems = [];
bool isLoading = true;
 int id=0;
final TextEditingController eCtrl = new TextEditingController();

class syncrohnScreen extends StatefulWidget {
  const syncrohnScreen({Key? key}) : super(key: key);

  @override
 _syncrohnScreenState createState() => _syncrohnScreenState();
}

class _syncrohnScreenState extends State<syncrohnScreen> {
  void initState() {
    _loadData();
    super.initState();
  }
  _loadData() async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    var id = sessionLogin.getInt("id").toString();
    var url = "https://okydigital.com/buzz_login/loadsync.php";
    //var res = await http.get(Uri.parse(url));
    var data = {
      "id_buzz":id,
    };
    var res = await http.post(Uri.parse(url), body: data);
    //String jsn ='[{"id":"17","firstname":"yassine","lastname":"doumil","company":"okysolutions","email":"yassinedoumil96@gmail.com","phone":"06877778787","adresse":"hay hassani casablanca","evolution":"bonne","action":"14","notes":"note1","created":"","updated":null},{"id":"18","firstname":"amine","lastname":"faouzi","company":"okysolutions","email":"amine.normane@gmail.com","phone":"089687676","adresse":"annassi casablanca","evolution":"moyenne","action":"23","notes":"note 2","created":"","updated":null},
    // {"id":"18","firstname":"amine","lastname":"faouzi","company":"okysolutions","email":"amine.normane@gmail.com","phone":"089687676","adresse":"annassi casablanca","evolution":"moyenne","action":"23","notes":"note 2","created":"","updated":null}]';
    List<Userscan> users = (json.decode(res.body) as List)
        .map((data) => Userscan.fromJson(data))
        .toList();
    litems=users;
    isLoading = false;
    if (this.mounted) {
      setState(() {});
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
        title: Text("Syncrohniser"),
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
      body: isLoading == true
          ? Center(
          child: SpinKitThreeBounce(
            color: Color(0xff682062),
            size: 50.0,
          ))
          : new ListView.builder(
          itemCount: litems.length,
          itemBuilder: (_, int position) {
            return new Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(50.0),
                    right: Radius.circular(0.0),
                  )
              ),
              child: new ListTile(
                leading: new ClipOval(
                    child: Image.asset(
                      'assets/av.jpg',
                    )),
                title:Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                 child: Text("${litems[position].firstname} ${litems[position].lastname}",
                   style: TextStyle(color: Colors.white70, fontSize: 15,fontWeight:FontWeight.bold),
                  ),
                ),
                subtitle: new Text("${litems[position].company}",
                  style: TextStyle(color: Colors.white70,height: 2),
                ),
                trailing: Wrap(
                  children: [
                    Text("${litems[position].evolution}\n\n${litems[position].created}",
                        style: TextStyle(color: Colors.white70, fontSize: 15,fontWeight:FontWeight.bold)),
                  ],
                ),
                onTap: (){},
              ),
              color: Color(0xff682062),
              elevation: 3.0,
            );
          }),
    );
  }
}
