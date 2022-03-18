import 'dart:convert';
import 'dart:io';
import 'package:assessment_task/brouillon_screen.dart';
import 'package:assessment_task/edit_screen.dart';
import 'package:assessment_task/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_task/model/user_scanner.dart';
import 'package:assessment_task/utils/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:assessment_task/view_csv_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String _data = "";
int _count = 0;
late SharedPreferences pr;
List<Userscan> litems = [];
bool isLoading = true;
late SharedPreferences prefs;
final TextEditingController eCtrl = new TextEditingController();

class profilsEnregistresScreen extends StatefulWidget {
  const profilsEnregistresScreen({Key? key}) : super(key: key);

  @override
  _profilsEnregistresScreenState createState() =>
      _profilsEnregistresScreenState();
}

class _profilsEnregistresScreenState extends State<profilsEnregistresScreen> {
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
    litems = await db.getListUser();
    //print(litems);
    isLoading = false;
    if (this.mounted) {
      setState(() {});
    }
  }

  _upload() async {
    List<List<dynamic>> listOfProfil = [];
    for (int i = 0; i < litems.length; i++) {
      List<dynamic> row = [];
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

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();
    if (statuses[Permission.storage]!.isGranted) {
      String csvData = ListToCsvConverter().convert(listOfProfil);
      String directory = "";
      if (Platform.isAndroid) {
        directory = "/Download";
      } else {
        directory = (await getApplicationDocumentsDirectory()).path;
      }
      final path = "$directory/csv-${DateTime.now()}.csv";
      final File file = File(path);
      await file.writeAsString(csvData);
      //final input =file.openRead();
      //final fields=await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
      //print(fields);
      print(csvData);
      print(path);
      print(file);
    } else {
      print("No permission to read and write.");
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
                              String userToBr = ("${litems[position].firstname}:${litems[position].lastname}:${litems[position].company}:${litems[position].email}:${litems[position].phone}:${litems[position].adresse}:${litems[position].evolution}:${litems[position].action}:${litems[position].notes}");
                              prefs = await SharedPreferences.getInstance();
                              prefs.setString("EditData", userToBr);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditScreen()));
                            },
                            icon: Icon(Icons.edit, color: Colors.white70)),
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
                              int res = await db.deleteUser(
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
                                            BrouillonScreen()));
                                setState(() {});
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.grey)),
                      ],
                    ),
                    onTap: () => debugPrint(litems[position].email.toString()),
                  ),
                  color: Color(0xff682062),
                  elevation: 3.0,
                );
              }),
    );
  }
}
