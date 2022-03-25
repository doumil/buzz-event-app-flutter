// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
        title: Text("Profile"),
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
      body: Column(
        children: [
          Stack(
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
          SizedBox(
            height: 45,
          ),
          ListTile(
            title: Center(child: Text("${fname} ${lname}")),
            subtitle: Center(child: Text("${company}")),
          ),
          ListTile(
            title: Text("${email}"),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text("${phone}"),
          ),
          SizedBox(
            height: 20,
          ),
        ],
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
