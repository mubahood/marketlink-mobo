import 'package:flutter/material.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/model/StockItemModel.dart';
import 'package:flutter_ui/screens/Auth/LandingScreen.dart';
import 'package:flutter_ui/screens/stock_categories/StockCategoriesScreen.dart';
import 'package:flutter_ui/screens/stock_categories/StockSubCategoriesScreen.dart';
import 'package:get/get.dart';

import '../model/Utils.dart';
import 'Common/AboutScreen.dart';
import 'Common/ContactUsScreen.dart';
import 'employees/EmployeesScreen.dart';
import 'financial_periods/FinancialPeriodsScreen.dart';

class MenuRoute2 extends StatefulWidget {
  MenuRoute2();

  @override
  State<MenuRoute2> createState() => _MenuRoute2State();
}

class _MenuRoute2State extends State<MenuRoute2> {
  LoggedInUser user = LoggedInUser();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myInit();
  }

  List<StockItemModel> stole_items = [];

  Future<void> myInit() async {
    stole_items = await StockItemModel.get_items();
    if (stole_items.isEmpty) {
      await StockItemModel.get_online_items();
      stole_items = await StockItemModel.get_items();
    }
    user = await LoggedInUser.getUser();
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: topSection(),
        backgroundColor: MyColors.primary,
      ),
      body: true
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  //are you sure you want to logout
                  Get.defaultDialog(
                    title: 'Logout',
                    middleText: 'Are you sure you want to logout?',
                    textConfirm: 'Yes',
                    textCancel: 'No',
                    confirmTextColor: Colors.white,
                    buttonColor: MyColors.primary,
                    onConfirm: () async {
                      await LoggedInUser.deleteAll();
                      Get.offAll(() => LandingScreen());
                    },
                  );
                },
                child: Text('Logout'),
              ),
            )
          : ListView(
              children: [
                Container(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      "Account & Settings",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    )),
                ListTile(
                  onTap: () {
                    Get.to(() => EmployeesScreen({}));
                  },
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      Icons.people,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: MyColors.primary,
                  ),
                  title: Text(
                    "My Employees",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => StockCategoriesScreen({}));
                  },
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      Icons.category,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: MyColors.primary,
                  ),
                  title: Text(
                    "Stock Categories",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => StockSubCategoriesScreen({}));
                  },
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      Icons.category,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: MyColors.primary,
                  ),
                  title: Text(
                    "Stock sub-categories",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => FinancialPeriodsScreen({}));
                  },
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: MyColors.primary,
                  ),
                  title: Text(
                    "Financial periods",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Utils.urlLauncher(Utils.API_URL.replaceAll('/api', ''));
                  },
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      Icons.table_chart_outlined,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: MyColors.primary,
                  ),
                  title: Text(
                    "Generate reports",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Utils.urlLauncher('https://forms.gle/KyRRfXqKZ5pTAhaq5');
                  },
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      Icons.file_copy,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: MyColors.primary,
                  ),
                  title: Text(
                    "Download my account and data",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => AboutScreen());
                  },
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: MyColors.primary,
                  ),
                  title: Text(
                    "About the App",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => ContactUsScreen());
                  },
                  leading: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    size: 30,
                    color: MyColors.primary,
                  ),
                  title: Text(
                    "Contact us",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      //are you sure you want to logout
                      Get.defaultDialog(
                        title: 'Logout',
                        middleText: 'Are you sure you want to logout?',
                        textConfirm: 'Yes',
                        textCancel: 'No',
                        confirmTextColor: Colors.white,
                        buttonColor: MyColors.primary,
                        onConfirm: () async {
                          await LoggedInUser.deleteAll();
                          Get.offAll(() => LandingScreen());
                        },
                      );
                    },
                    child: Text('Logout'),
                  ),
                ),
              ],
            ),
    );
  }

  topSection() {
    return Row(
      children: [
        Text('My Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.2,
            )),
      ],
    );
  }

  menuWidget1(String t, String c, IconData icon, Function onTap) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFFFBF5F5),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: MyColors.primary, width: .5)),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Icon(
                  icon,
                  size: 25,
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: MyColors.primary,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      t,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                          height: 1),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      height: 0,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      c,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          height: 1),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
