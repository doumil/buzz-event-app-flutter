import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_task/model/user_scanner.dart';
import 'package:assessment_task/utils/database_helper.dart';
String _data="";
int _count=0;
late SharedPreferences pr;
List<Userscan> litems=[];
final TextEditingController eCtrl = new TextEditingController();
class profilsEnregistresScreen extends StatefulWidget {
  const profilsEnregistresScreen({Key? key}) : super(key: key);

  @override
  _profilsEnregistresScreenState createState() => _profilsEnregistresScreenState();
}

class _profilsEnregistresScreenState extends State<profilsEnregistresScreen> {
  void initState() {
    super.initState();
    _loadData();
  }
  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
        //_data =(prefs.getString("Data")??'');
        var db = new DatabaseHelper();
        //print(await db.getAllUsers());
        //print(await db.getListUser());
        //print('hello from profils');
        litems=await db.getListUser();
        //print(litems.length);
         print(litems);
        //email:  result.substring(place.elementAt(0)+1,place.elementAt(1))
         String str ="yassine doumil yassinedoumil@gmail.com";



    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: Text("Profils Enregistrés"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 0),
          )
        ],
        centerTitle:true,
        flexibleSpace: Container(
          decoration:BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft ,
                  end: Alignment.centerRight ,
                  colors: [Color.fromRGBO(103, 33, 96, 1.0),Colors.black])
          ),

        ),
      ),
      body: new ListView.builder(
          itemCount: litems.length,
          itemBuilder: ( _ ,int  position ){
            return new Card(
              child: new ListTile(
                leading: new Icon(Icons.person,color: Colors.white,size: 33.0),
                title: new Text(litems[position].email.toString()),
                subtitle: new Text("${litems[position].firstname.toString()} ${litems[position].lastname.toString()}"),
                onTap: () => debugPrint(litems[position].email.toString()),
              ),
              color: Colors.amber,
              elevation: 3.0,

            );

          }),
    );
  }
}