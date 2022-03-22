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
    var url = "http://192.168.1.179/buzz_login/login.php";
    var res = await http.get(Uri.parse(url));
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
                title: new Text("",
                  style: TextStyle(color: Colors.white70, fontSize: 15,fontWeight:FontWeight.bold),
                ),
                subtitle: new Text("",
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Wrap(
                  children: [],
                ),
                onTap: (){},
              ),
              color: Colors.grey,
              elevation: 3.0,
            );
          }),
    );
  }
}
