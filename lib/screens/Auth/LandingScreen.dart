import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/screens/Auth/LoginScreen.dart';
import 'package:get/get.dart';

import '../../data/img.dart';
import '../../model/Utils.dart';
import '../MenuRoute.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen();

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LoggedInUser newUser = LoggedInUser();

  String company_name = "";
  String currency = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.primary,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: MyColors.primary),
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 30,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  myInit();
                },
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      Img.get('logo.png'),
                    ),
                  ),
                  width: 200,
                  height: 200,
                ),
              ),
              Container(height: 15),
              //WELCOME TO TEXT
              Text(
                "Welcome to",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                Utils.APP_NAME,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
              Spacer(),
              Divider(
                indent: 100,
                endIndent: 100,
              ),
              SizedBox(
                height: 10,
              ),
              //tagline
              Text(
                "Contributions & Budgeting System",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ));
  }

  String error = "";
  LoggedInUser user = LoggedInUser();

  void myInit() async {
    user = await LoggedInUser.getUser();
    await Future.delayed(Duration(seconds: 4));
    if (user.id < 1) {
      Utils.toast("Please login first.", c: Colors.red);
      Get.offAll(() => LoginScreen());
      return;
    }
    //welcome user
    Utils.toast("Welcome ${user.first_name} ${user.last_name}",
        c: Colors.green);
    Get.offAll(() => MenuRoute());
  }
}
