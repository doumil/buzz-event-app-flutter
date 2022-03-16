import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_task/model/user_scanner.dart';
import 'package:assessment_task/utils/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:assessment_task/view_csv_data.dart';
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
      //email:  result.substring(place.elementAt(0)+1,place.elementAt(1))
        //_data =(prefs.getString("Data")??'');
        //print(await db.getAllUsers());
        //print(await db.getListUser());
        //print('hello from profils');
        // print(litems.length);
         var db = new DatabaseHelper();
         litems=await db.getListUser();
         //print(litems);
         //print('here a profile');
    });
  }
  _upload() async{
    List<List<dynamic>> listOfProfil = [];
    for (int i = 0; i < litems.length; i++) {

      List<dynamic> row =[];
      row.add(litems[i].firstname);
      row.add(litems[i].lastname);
      row.add(litems[i].company);
      row.add(litems[i].email);
      row.add(litems[i].phone);
      row.add(litems[i].adresse);
      row.add(litems[i].evolution);
      row.add(litems[i].action);
      row.add(litems[i].notes);
      listOfProfil.add(row);
    }
    //<String>['first name', 'lastname', 'company','email','phone','adresse','evolution','Action','notes'],

    String csvData = ListToCsvConverter().convert(listOfProfil);
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/csv-${DateTime.now()}.csv";
    final File file=File(path);
    await file.writeAsString(csvData);
     //final input =file.openRead();
     //final fields=await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
     //print(fields);
    print(csvData);
    print(path);
    print(file);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: Text("Profils Enregistrés"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.upload_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              _upload();
            },
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
                leading: new ClipOval(child:Image.asset('assets/av.jpg',)),
                title: new Text(litems[position].email.toString(),style: TextStyle(color: Colors.white70),),
                subtitle: new Text("${litems[position].firstname.toString()} ${litems[position].lastname.toString()}",style: TextStyle(color: Colors.white70),),
                onTap: () => debugPrint(litems[position].email.toString()),
              ),
              color: Color(0xff682062),
              elevation: 3.0,
            );
          }),
    );
  }
}