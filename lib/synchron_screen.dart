import 'dart:convert';
import 'dart:io';
import 'package:assessment_task/home_screen.dart';
import 'package:assessment_task/syncedit_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment_task/model/user_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:assessment_task/profils_enregistrés.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

late SharedPreferences pr;
List<Userscan> litems = [];
String lang="";
bool isLoading = true;
 int id=0;
final TextEditingController eCtrl = new TextEditingController();

class SynchronScreen extends StatefulWidget {
  const SynchronScreen({Key? key}) : super(key: key);

  @override
 _SynchronScreenState createState() => _SynchronScreenState();
}

class _SynchronScreenState extends State<SynchronScreen> {
  void initState() {
     litems.clear();
     isLoading = true;
    _loadData();
    super.initState();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lang =prefs.getString("lang")!;
    print(lang);
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
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
   // }
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
        title: Text("Synchroniser".tr),
        actions: <Widget>[
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  child: ListTile(
                    leading: Icon(Icons.upload_sharp),
                    title: Container(width:double.maxFinite ,child: Text("Exporter .csv".tr)),
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
          decoration: BoxDecoration(
              gradient: LinearGradient(
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
                    Text("${litems[position].evolution}\n${litems[position].created}\n${litems[position].updated}",
                        style: TextStyle(color: Colors.white70, fontSize: 15,fontWeight:FontWeight.bold)),
                    IconButton(
                        onPressed: () async {
                          String userToBr =
                          ("${litems[position].lastname}:${litems[position].firstname}:${litems[position].company}:${litems[position].profession}:${litems[position].email}:${litems[position].phone}:${litems[position].evolution}:${litems[position].action}:${litems[position].notes}:${litems[position].created}");
                          prefs = await SharedPreferences.getInstance();
                          prefs.setString("EditDataSync", userToBr);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditsyncScreen()));
                        },
                        icon: Icon(Icons.edit, color: Colors.white70)),
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
