import 'dart:io';
import 'package:assessment_task/Profil.dart';
import 'package:assessment_task/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_task/model/user_scanner.dart';
import 'package:assessment_task/utils/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:assessment_task/profils_enregistrés.dart';

String _data = "";
int _count = 0;
late SharedPreferences pr;
List<Userscan> litems = [];
bool isLoading = true;
final TextEditingController eCtrl = new TextEditingController();

class BrouillonScreen extends StatefulWidget {
  const BrouillonScreen({Key? key}) : super(key: key);

  @override
  _BrouillonScreenState createState() =>
      _BrouillonScreenState();
}

class _BrouillonScreenState extends State<BrouillonScreen> {
  void initState() {
    _loadData();
    super.initState();

  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //email:  result.substring(place.elementAt(0)+1,place.elementAt(1))
    //_data =(prefs.getString("Data")??'');
    //print(await db.getAllUsers());
    //print(await db.getListUser());
    //print('hello from profils');
    // print(litems.length);
    var db = new DatabaseHelper();
    litems = await db.getListBrouillon();
    //print(litems);
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
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Brouillon"),
        actions: <Widget>[
        ],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color.fromRGBO(103, 33, 96, 1.0), Colors.black])),
        ),
      ),
      body:
      isLoading==true ? Center(
          child: SpinKitThreeBounce(
            color: Color(0xff682062),
            size: 50.0,
          )
      ) :
      new ListView.builder(
          itemCount: litems.length,
          itemBuilder: (_, int position) {
            return new Card(
              child: new ListTile(
                leading: new ClipOval(
                    child: Image.asset(
                      'assets/av.jpg',
                    )),
                title: new Text(
                  litems[position].email.toString(),
                  style: TextStyle(color: Colors.white70),
                ),
                subtitle: new Text(
                  "${litems[position].firstname.toString()} ${litems[position].lastname.toString()}",
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Wrap(
                  children: [
                    IconButton(
                        onPressed: () async {
                          var db = new DatabaseHelper();
                          Userscan userToBr = Userscan(
                              litems[position].firstname,
                              litems[position].lastname,
                              litems[position].company,
                              litems[position].email,
                              litems[position].phone,
                              litems[position].adresse,
                              litems[position].evolution,
                              litems[position].action,
                              litems[position].notes);
                          int res = await db.restoreUser(
                              litems[position].email.toString(), userToBr);
                          print(res);
                          if (res > 0) {
                            litems.removeWhere((element) =>
                            element.email ==
                                litems[position].email.toString());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        profilsEnregistresScreen()));
                            setState(() {});
                          }
                        },
                        icon: Icon(Icons.restore, color: Colors.white70)),
                    IconButton(
                        onPressed: () async {
                          var db = new DatabaseHelper();
                          int res=await db.deleteBrouillon(litems[position].email.toString());
                          print(res);
                          if(res>0)
                          {
                            litems.removeWhere((element) => element.email==litems[position].email.toString());
                            setState(() {
                            });
                          }
                        },
                        icon: Icon(Icons.delete, color:Color(0xff803b7a))),
                  ],
                ),
                onTap: () => debugPrint(litems[position].email.toString()),
              ),
              color:Colors.grey,
              elevation: 3.0,
            );
          }),
    );
  }
}
