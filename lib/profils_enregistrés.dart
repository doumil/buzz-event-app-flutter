import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
String _data="";
int _index=0;
late SharedPreferences pr;
List<String> litems = [];
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
      _data = (prefs.getString('Data')??'');
      if(pr.getStringList("")==null) {
        litems.add(_data);
      }
      else{
        litems.add(pr.getStringList("").toString());
      }
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
        body: new Column(
          children: <Widget>[
            new Expanded(
                child: new ListView.builder
                  (
                    itemCount: litems.length,
                    itemBuilder: (BuildContext context, int Index) {

                      return new Text(litems[Index]);
                    }
                )
            ),
            Container(
             child : FlatButton(
                child: Text('Save', style: TextStyle(fontSize: 20.0),),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () async {
                  pr = await SharedPreferences.getInstance();
                  pr.setStringList("listems", litems);
                },
              ),
            )
          ],
        )
    );
  }
}