import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'welcome_screen.dart';


class FirstPageSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: FirsPage(),
    );
  }
}
class FirsPage extends StatelessWidget {

  final Color kDarkBlueColor = const Color(0xff692062);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return OnBoardingSlider(
      finishButtonText: 'Commencez',
      onFinish: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      },
      finishButtonColor: kDarkBlueColor,
      skipTextButton: Text(
        'Ignorer',
        style: TextStyle(
          fontSize: 16,
          color: kDarkBlueColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        'Ignorer',
        style: TextStyle(
          fontSize: 16,
          color: kDarkBlueColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        );
      },
      controllerColor: kDarkBlueColor,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      imageHorizontalOffset:width*0.25,
      imageVerticalOffset: height*0.2,
      background: [
        Image.asset('assets/intro_photo1.png', width: 200,height: 200),
        Image.asset('assets/intro_photo2.png',width: 250,height: 250),
        Image.asset('assets/intro_photo3.png',width: 300,height: 300),
      ],
      speed: 2,
      pageBodies: [
        Container(
          //padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              Text(
                'Scannez',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkBlueColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Vous pouvez scannez le code QR\n ou le code-barre de votre visiteur',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff692062),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          margin: EdgeInsets.only(top: height * 0.63),
          padding: EdgeInsets.only(bottom: height * 0.01),
          width: width * 0.9,
        ),
        Container(
         // padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Evaluez et enregistez',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkBlueColor,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Valorisez, prenez des notes \n et enregistrez les profils \ndans votre téléphone',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff692062),
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          margin: EdgeInsets.only(top: height * 0.63),
          padding: EdgeInsets.only(bottom: height * 0.01),
          width: width * 0.9,
        ),
        Container(
         // padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.04,
                      width * 0.04,
                      width * 0.04,
                      width * 0.01),
                  child:Text(
                    'Sychronisez',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kDarkBlueColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      10, 10, 10, 0),
                  child: Container(
                      child:Text(
                        'Synchronisez les données de l\'application\n avec notre base de données',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff692062),
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ) ),
                ),
              )
            ],
          ),
          margin: EdgeInsets.only(top: height * 0.63),
          padding: EdgeInsets.only(bottom: height * 0.01),
          width: width * 0.9,
        ),
      ],
    );
  }
}