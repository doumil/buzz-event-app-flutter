import 'dart:io';
import 'package:assessment_task/brouillon_screen.dart';
import 'package:assessment_task/edit_screen.dart';
import 'package:assessment_task/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_task/model/user_scanner.dart';
import 'package:assessment_task/utils/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assessment_task/synchron_screen.dart';

String _data = "",lang="";
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
      lang =prefs.getString("lang")!;
      print(lang);
    var db = new DatabaseHelper();
    litems = await db.getListUser();
    //print(litems);
    isLoading = false;
    if (this.mounted) {
      setState(() {});
    }
  }
  _upload() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    Userscan userCsv = Userscan(
        'nom'.tr,
        'prénom'.tr,
        'entreprise'.tr,
        'profession'.tr,
        'e-mail'.tr,
        'téléphone'.tr,
        'évolution'.tr,
        'action'.tr,
        'Remarques'.tr,
        'date de création'.tr,
        'date de modification'.tr);
    List<Userscan> listCsv = [];
    listCsv.add(userCsv);
    listCsv += litems;
    for (var i = 1; i <= listCsv.length; i++) {
      sheet
          .getRangeByName('A${i}')
          .setText(listCsv[i - 1].lastname.toString());
      sheet.getRangeByName('B${i}').setText(listCsv[i - 1].firstname.toString());
      sheet.getRangeByName('C${i}').setText(listCsv[i - 1].company.toString());
      sheet.getRangeByName('D${i}').setText(listCsv[i - 1].profession.toString());
      sheet.getRangeByName('E${i}').setText(listCsv[i - 1].email.toString());
      sheet.getRangeByName('F${i}').setText(listCsv[i - 1].phone.toString());
      sheet
          .getRangeByName('G${i}')
          .setText(listCsv[i - 1].evolution.toString());
      sheet.getRangeByName('H${i}').setText(listCsv[i - 1].action.toString());
      sheet.getRangeByName('I${i}').setText(listCsv[i - 1].notes.toString());
      sheet.getRangeByName('I${i}').setText(listCsv[i - 1].created.toString());
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    // if (kIsWeb) {
    // AnchorElement(
    // href:
    //    'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
    //..setAttribute('download', 'Profils${DateTime.now().hour}${DateTime.now().minute}.csv')
    //..click();
    // } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName = Platform.isWindows
          ? '$path\\Profils${DateTime.now().hour}${DateTime.now().minute}.csv'
          : '$path/Profils${DateTime.now().hour}${DateTime.now().minute}.csv';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    //}
  }

  void _sync() async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    var id = sessionLogin.getInt("id").toString();
    setState(() {});
    var url = "https://okydigital.com/buzz_login/sync.php";
    for (var i = 0; i < litems.length; i++) {
      var dt = {
        "lastname": litems[i].lastname.toString(),
        "firstname": litems[i].firstname.toString(),
        "company": litems[i].company.toString(),
        "profession": litems[i].profession.toString(),
        "email": litems[i].email.toString(),
        "phone": litems[i].phone.toString(),
        "evolution": litems[i].evolution.toString(),
        "action": litems[i].action.toString(),
        "notes": litems[i].notes.toString(),
        "created": litems[i].created.toString(),
        "updated": litems[i].updated.toString(),
        "id_buzz": id,
      };
      print(dt);
      await http.post(Uri.parse(url), body: dt);
    }
    var db = new DatabaseHelper();
    await db.deleteTosync();
    litems.removeRange(0, litems.length);
    Fluttertoast.showToast(
        msg: "contenu Enregistré avec succès", toastLength: Toast.LENGTH_SHORT);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SynchronScreen()));
    if (this.mounted) {
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
        title: Text("Profils Enregistrés".tr),
        actions: <Widget>[
          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                child: ListTile(
                  leading: Icon(Icons.sync_sharp),
                  title: Container( width:double.maxFinite,child: Text("Synchroniser".tr,overflow: TextOverflow.ellipsis,)),
                  onTap: () {
                    _sync();
                  },
                  trailing: Wrap(
                    children: <Widget>[
                       Icon(
                        Icons.upload_sharp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuItem<int>(
                child: ListTile(
                  leading: Icon(Icons.upload_sharp),
                  title: Container( width:double.maxFinite,child: Text("Exporter .csv".tr)),
                  onTap: () {
                    _upload();
                  },
                  trailing: Wrap(
                    children: <Widget>[],
                  ),
                ),
              ),
            ];
          },),
        ],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: LinearGradient(
              //begin: Alignment.centerLeft,
              //end: Alignment.centerRight,
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
                  )),
                  color: Color(0xff682062),
                  child: new ListTile(
                    leading: Container(
                      child: new ClipOval(
                          child: Image.asset(
                        'assets/av.jpg',
                      )),
                    ),
                    title: new Text(
                      "${litems[position].firstname.toString()} ${litems[position].lastname.toString()}",
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: new Text(
                      "${litems[position].company.toString()}   ${litems[position].created.toString()}\n${litems[position].updated.toString()}",
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            onPressed: () async {
                              String userToBr =
                                  ("${litems[position].lastname}:${litems[position].firstname}:${litems[position].company}:${litems[position].profession}:${litems[position].email}:${litems[position].phone}:${litems[position].evolution}:${litems[position].action}:${litems[position].notes}:${litems[position].created}");
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
                                  litems[position].lastname,
                                  litems[position].firstname,
                                  litems[position].company,
                                  litems[position].profession,
                                  litems[position].email,
                                  litems[position].phone,
                                  litems[position].evolution,
                                  litems[position].action,
                                  litems[position].notes,
                                  litems[position].created,
                                  litems[position].updated);
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
                    onLongPress: () async {},
                  ),
                  elevation: 3.0,
                );
              }),
    );
  }
}
