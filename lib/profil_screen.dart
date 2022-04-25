// ignore_for_file: prefer_const_constructors
import 'package:assessment_task/editProfil_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/countries.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  late var id,email,fname,lname,company,phone;
  String phonewithcode="",code="MA";

  void initState() {
    _loadData();
    super.initState();
  }
  _loadData() async {
    SharedPreferences sessionLogin = await SharedPreferences.getInstance();
    id      = sessionLogin.getInt("id");
    email   = sessionLogin.getString("email");
    fname   = sessionLogin.getString("fname");
    lname   = sessionLogin.getString("lname");
    company = sessionLogin.getString("company");
    phonewithcode = sessionLogin.getString("phone").toString();
    var ss = phonewithcode.split(",");
    List<String> list1 = [];
    ss.forEach((e) {
      list1.add(e);
    });
    phone="${list1.elementAt(0)}${list1.elementAt(2)}";
    //code=phonewithcode.substring(0,2);
    //phone=phonewithcode.substring(2,phonewithcode.length);
    setState(() {
    });
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
        title: Text("Profile ${fname} ${lname}"),
        actions: <Widget>[
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context){
                return [
                  PopupMenuItem<int>(
                    child:ListTile(
                    leading: Icon(Icons.person),
                    title: Text("modifier le profile"),
                    onTap: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfilScreen()));
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
                ];
              },
          ),
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        child: Image(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 3,
                          fit: BoxFit.cover,
                          image: AssetImage("assets/background-buz2.png"),
                        ),
                      ),
                      Positioned(
                          bottom: -50.0,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Color(0xff692062),
                            child: CircleAvatar(
                                radius: 75,
                                backgroundImage: AssetImage("assets/profil.jpg")
                            ),
                          ))
                    ]),
              ),
              SizedBox(
                height: 50,
              ),
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: ListTile(
                  title: Center(child: Text("${fname} ${lname}",
                      style: TextStyle(fontSize: 20,color: Color(0xff692062),fontWeight: FontWeight.bold),)),
                ),
              ),
              //company
              SizedBox(
                height:10,
              ),
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: new Divider(
                  color: Color.fromRGBO(150, 150, 150, 0.4),
                  height: 5.0,
                ),
              ),
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: ListTile(
                  leading: Icon(Icons.home_work_rounded),
                  title:Text("${company}"),
                  onTap: () {
                  },
                  trailing: Wrap(
                    children: <Widget>[
                    ],
                  ),
                ),
              ),
              //email
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: new Divider(
                  color: Color.fromRGBO(150, 150, 150, 0.4),
                  height: 5.0,
                ),
              ),
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: ListTile(
                  enabled: false,
                  leading: Icon(Icons.email),
                  title:Text("${email}"),
                  onTap: () {
                  },
                ),
              ),
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: new Divider(
                  color: Color.fromRGBO(150, 150, 150, 0.4),
                  height: 5.0,
                ),
              ),
              //phone
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("${phone}"),
                  onTap: () {
                  },
                  trailing: Wrap(
                    children: <Widget>[ // icon-1// icon-2
                    ],
                  ),
                ),
              ),
              FadeInDown(
                duration: Duration(milliseconds: 500),
                child: new Divider(
                  color: Color.fromRGBO(150, 150, 150, 0.4),
                  height: 5.0,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color(0xff692062),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.github),
            label: 'github',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.linkedin),
            label: 'linkedin',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.facebook),
            label: 'facebook',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.instagram),
            label: 'instagram',
          ),
        ],
        selectedItemColor: Color(0xff692062),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
