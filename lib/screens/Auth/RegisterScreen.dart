import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/screens/Auth/LoginScreen.dart';
import 'package:get/get.dart';

import '../../data/img.dart';
import '../../data/my_theme.dart';
import '../../model/Utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen();

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  LoggedInUser newUser = LoggedInUser();

  String company_name = "";
  String currency = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.primary,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarDividerColor: MyColors.primary,
              systemNavigationBarColor: MyColors.primary,
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Image.asset(
                    Img.get('logo.png'),
                  ),
                  width: 100,
                  height: 100,
                ),
                Container(height: 15),
                Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 15),
                TextField(
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.white),
                  decoration: MyTheme.inputStyle1('First Name'),
                  onChanged: (value) {
                    newUser.first_name = value.toString();
                  },
                ),
                Container(height: 5),
                TextField(
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.white),
                  decoration: MyTheme.inputStyle1('Last Name'),
                  onChanged: (value) {
                    newUser.last_name = value.toString();
                  },
                ),
                Container(height: 5),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  decoration: MyTheme.inputStyle1('Email Address'),
                  onChanged: (value) {
                    newUser.email = value.toString();
                  },
                ),
                Container(height: 5),
                TextField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.white),
                  decoration: MyTheme.inputStyle1('Phone number'),
                  onChanged: (value) {
                    newUser.phone_number = value.toString();
                  },
                ),
                Container(height: 5),
                TextField(
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.white),
                  decoration: MyTheme.inputStyle1('Company Name'),
                  onChanged: (value) {
                    company_name = value.toString();
                  },
                ),
                Container(height: 5),
                TextField(
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.white),
                  decoration: MyTheme.inputStyle1('Currency'),
                  onChanged: (value) {
                    currency = value.toString();
                  },
                ),
                Container(height: 5),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(color: Colors.white),
                  decoration: MyTheme.inputStyle1('Password'),
                  onChanged: (value) {
                    newUser.password = value.toString();
                  },
                ),
                Container(height: 25),
                Container(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryLight,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5)),
                    ),
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      validate_form();
                    },
                  ),
                ),
                error.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : Container(),
                Container(height: 15),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.transparent),
                    child: Text(
                      "Already have account? Login",
                      style: TextStyle(color: Colors.red[100]),
                    ),
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                  ),
                ),
                SizedBox(
                  height: Get.height / 6,
                ),
              ],
            ),
          ),
        ));
  }

  void validate_form() {
    if (newUser.first_name.isEmpty) {
      Get.snackbar(
        "Error",
        "First name is required.",
        backgroundColor: Colors.red[100],
      );
      return;
    }
    if (newUser.last_name.isEmpty) {
      Get.snackbar(
        "Error",
        "Last name is required.",
        backgroundColor: Colors.red[100],
      );
      return;
    }
    if (newUser.email.isEmpty) {
      Get.snackbar(
        "Error",
        "Email is required.",
        backgroundColor: Colors.red[100],
      );
      return;
    }

    if (company_name.length < 3) {
      Get.snackbar(
        "Error",
        "Company name is required.",
        backgroundColor: Colors.red[100],
      );
      return;
    }

    if (currency.length < 1) {
      Get.snackbar(
        "Error",
        "Currency is required.",
        backgroundColor: Colors.red[100],
      );
      return;
    }

    if (newUser.password.length < 4) {
      Get.snackbar(
        "Error",
        "Password must be at least 4 characters.",
        backgroundColor: Colors.red[100],
      );
      return;
    }
    submit();
  }

  final dio = Dio();
  String error = "";
  LoggedInUser user = LoggedInUser();

  void submit() async {
    Utils.showLoader(false);
    setState(() {
      error = '';
    });
    var resp = null;

    Map<String, dynamic> uploadData = newUser.toJson();
    uploadData['company_name'] = company_name;
    uploadData['currency'] = currency;

    try {
      resp = await dio.post(
        '${Utils.API_URL}auth/register',
        data: json.encode(uploadData),
        options: Options(headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }),
      );
    } catch (e) {
      error = e.toString();
      resp = null;
    }

    print("=====REGISTERING END=====");
    Utils.hideLoader();
    if (resp == null) {
      Get.snackbar("Error", error, backgroundColor: Colors.red[100]);
      return;
    }

    if (resp.data == null) {
      error = "Failed to register because ${resp.statusMessage}.";
      Get.snackbar("Error", "Failed to register",
          backgroundColor: Colors.red[100]);
      return;
    }

    //if resp.data is not map
    if (!resp.data.runtimeType.toString().toLowerCase().contains('map')) {
      error = "Failed to register because ${resp.statusMessage}.";
      Get.snackbar("Error", "Failed to register",
          backgroundColor: Colors.red[100]);
      return;
    }

    if (resp.data['code'].toString() != '1') {
      error = resp.data['message'];
      Get.snackbar("Error", error, backgroundColor: Colors.red[100]);
      setState(() {});
      return;
    }
    user = LoggedInUser.fromJson(resp.data['data']['user']);
    if (user.id == 0) {
      error = 'Failed to parse user data. Try to login with your credentials.';
      Get.snackbar("Error", error, backgroundColor: Colors.red[100]);
      setState(() {});
      return;
    }

    String saving_resp = await user.save();
    if (saving_resp.isNotEmpty) {
      error = saving_resp;
      Get.snackbar("Error", saving_resp, backgroundColor: Colors.red[100]);
      setState(() {});
      return;
    }
    //toast success
    Get.snackbar("Success", "Welcome ${user.first_name}",
        backgroundColor: Colors.green[100]);
    Get.offAllNamed('/MenuRoute');
  }
}
