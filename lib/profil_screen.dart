// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'editprofile/company_screen.dart';
import 'editprofile/name_screen.dart';
import 'editprofile/phone_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  late var id,email,fname,lname,company,phone;
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
    phone   = sessionLogin.getString("phone");
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
                  leading: Icon(Icons.person),
                  title: Center(child: Text("${fname} ${lname}",
                      style: TextStyle(fontSize: 20,color: Color(0xff692062),fontWeight: FontWeight.bold),)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NameScreen()));
                  },
                  trailing: Wrap(
                    children: <Widget>[
                      Icon(Icons.edit,size: 20,), // icon-1// icon-2
                    ],
                  ),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CompanyScreen()));
                  },
                  trailing: Wrap(
                    children: <Widget>[
                      Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()));
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PhoneScreen()));
                  },
                  trailing: Wrap(
                    children: <Widget>[
                      Icon(Icons.keyboard_arrow_right), // icon-1// icon-2
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
