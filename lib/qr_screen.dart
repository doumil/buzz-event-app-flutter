import 'dart:async';

import 'package:assessment_task/profils_enregistr%C3%A9s.dart';
import 'package:assessment_task/utils/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'détails_screen.dart';
import 'model/user_scanner.dart';

class QrcodeScreen extends StatefulWidget {
  const QrcodeScreen({Key? key}) : super(key: key);
  static const customSwatch = MaterialColor(
    0xFFFF5252,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFFF5252),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );
  @override
  _QrcodeScreenState createState() => _QrcodeScreenState();
}

class _QrcodeScreenState extends State<QrcodeScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds:20), (Timer t) => moved());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  moved(){
    setState(() {
      if (bottom == 1 || top == 0) {
        bottom = 0;
        top = 1;
      } else if (top == 1 || bottom == 0) {
        top = 0;
        bottom = 1;
      }
    });
  }
  var bottom = 1;
  var top = 0;
  var response;
  var updated = "";
  var db = new DatabaseHelper();
  String _data = "";
  List<String> litems = [];
  Userscan user1 = Userscan('', '', '', '', '', '', '', '', '', '', '');
  late SharedPreferences prefs;
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          MobileScanner(
            allowDuplicates: true,
            controller: cameraController,
            onDetect: _foundBarcode,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.black.withOpacity(0.3),
              width: MediaQuery.of(context).size.width,
              height: 100,
              //MediaQuery.of(context).size.height,
              //margin: EdgeInsets.only(top:60),
              child: Center(
                child: Text('Scanner',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xff682062), width: 8),
                        left: BorderSide(color: Colors.white, width: 8),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xff682062), width: 8),
                          right: BorderSide(color: Colors.white, width: 8),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 8),
                          right: BorderSide(color: Color(0xff682062), width: 8),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 8),
                          left: BorderSide(color: Color(0xff682062), width: 8),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    height: 200,
                    width: 200,
                    margin: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                        // color: Colors.red.withOpacity(1.0),
                        ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn,
                            bottom: bottom == 0 ? 0 : null,
                            top: top == 0 ? 0 : null,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 1.32,
                                color: Colors.black,
                                child: Text("test"),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        color: Colors.white,
                        icon: ValueListenableBuilder(
                          valueListenable: cameraController.torchState,
                          builder: (context, state, child) {
                            switch (state as TorchState) {
                              case TorchState.off:
                                return const Icon(Icons.flash_off,
                                    color: Colors.grey);
                              case TorchState.on:
                                return const Icon(Icons.flash_on,
                                    color: Colors.white);
                            }
                          },
                        ),
                        iconSize: 32.0,
                        onPressed: () => cameraController.toggleTorch(),
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: ValueListenableBuilder(
                          valueListenable: cameraController.cameraFacingState,
                          builder: (context, state, child) {
                            switch (state as CameraFacing) {
                              case CameraFacing.front:
                                return const Icon(Icons.camera_front);
                              case CameraFacing.back:
                                return const Icon(Icons.camera_rear);
                            }
                          },
                        ),
                        iconSize: 32.0,
                        onPressed: () => cameraController.switchCamera(),
                      ),
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]),
              )),
        ],
      ),
    );
  }

  void _foundBarcode(Barcode barcode, MobileScannerArguments? args) async {
    /// open screen
    if (!_screenOpened) {
      final String code = barcode.rawValue ?? "-1";
      print(code);
      debugPrint('Barcode found! $code');
      _screenOpened = true;
      int _count = 0;
      prefs = await SharedPreferences.getInstance();
      prefs.setString("Data", code.toString());
      if (code != '-1') {
        var ss = code.split(";");
        List<String> list1 = [];
        ss.forEach((e) {
          list1.add(e);
          _count++;
        });
        print(_count);
        print(code);
        if (_count == 6) {
          print(_count);
          //Userscan user1=Userscan('khalid','fayzi','ok solution','faw@gmail.com','068798738','hay hassani casablanca','Evo','Act','Not');
          user1 = Userscan(
              list1.elementAt(0),
              list1.elementAt(1),
              list1.elementAt(2),
              list1.elementAt(3),
              list1.elementAt(4),
              list1.elementAt(5),
              '',
              '',
              '',
              '',
              '');
          response = await db.getUsersByemail(user1.email.toString());
          print("------------------------------");
          print(response);
          print("------------------------------");
          if (response.toString() == "[]") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DetailsScreen()));
          } else if (response.toString() != "[]") {
            user1.evolution = response[0]["evolution"];
            user1.action = response[0]["action"];
            user1.notes = response[0]["notes"];
            user1.created = response[0]["created"];
            user1.updated =
                "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}";
            db.updateUser(user1, user1.email);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => profilsEnregistresScreen()));
          }
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('erreur'),
              content: Text('QR code format invalid\n\n'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK',
                      style: TextStyle(color: Color(0xff803b7a))),
                ),
              ],
            ),
          );
        }
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('erreur'),
            content: const Text(
                'La devise n\'a pas été complétée avec succès. Veuillez réessayer'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK',
                    style: TextStyle(color: Color(0xff803b7a))),
              ),
            ],
          ),
        );
      }
    }
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
