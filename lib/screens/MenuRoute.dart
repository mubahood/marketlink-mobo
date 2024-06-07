import 'package:flutter/material.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/BudgetItemModel.dart';
import 'package:flutter_ui/model/ContributionRecordModel.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/model/StockItemModel.dart';
import 'package:flutter_ui/screens/Auth/LandingScreen.dart';
import 'package:flutter_ui/screens/reports/FinancialReportsScreen.dart';
import 'package:flutter_ui/screens/stock_categories/StockCategoriesScreen.dart';
import 'package:flutter_ui/screens/stock_categories/StockSubCategoriesScreen.dart';
import 'package:flutter_ui/screens/stock_items/StockItemsScreen.dart';
import 'package:get/get.dart';

import '../model/Utils.dart';
import '../widget/widgets.dart';
import 'Common/AboutScreen.dart';
import 'Common/ContactUsScreen.dart';
import 'MenuRoute2.dart';
import 'budget_management/budget/BudgetItemCategoriesScreen.dart';
import 'budget_management/contributions/ContributionRecordsScreen.dart';
import 'employees/EmployeesScreen.dart';
import 'finance/TransactionList.dart';
import 'financial_periods/FinancialPeriodsScreen.dart';

class MenuRoute extends StatefulWidget {
  MenuRoute();

  @override
  State<MenuRoute> createState() => _MenuRouteState();
}

class _MenuRouteState extends State<MenuRoute> {
  LoggedInUser user = LoggedInUser();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myInit();
  }

  List<StockItemModel> stole_items = [];

  Future<void> myInit() async {
    await BudgetItemModel.get_items();
    await ContributionRecordModel.get_items();
    /*if (stole_items.isEmpty) {
      await StockItemModel.get_online_items();
      stole_items = await StockItemModel.get_items();
    }*/
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              size: 40,
            ),
            onPressed: () {
              Get.to(() => MenuRoute2());
            },
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: true
          ? RefreshIndicator(
              onRefresh: () async {
                await myInit();
                return;
              },
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 0,
                                    top: 10,
                                    right: 0,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          menuWidget1(
                                            'Contribution Records',
                                            'Manage all your contribution records.',
                                            Icons.monetization_on_outlined,
                                            () {
                                              Get.to(() =>
                                                  ContributionRecordsScreen(
                                                      {}));
                                            },
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          menuWidget1(
                                            'Budget Management',
                                            'Manage all your budget records.',
                                            Icons.pie_chart,
                                            () {
                                              Get.to(() =>
                                                  BudgetItemCategoriesScreen(
                                                      {}));
                                            },
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          menuWidget1(
                                            'My Sales',
                                            'Manage all your sales in one place.',
                                            Icons.shopping_cart,
                                            () {
/*                                              Get.to(
                                                  () => StockRecordsScreen());*/
                                            },
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          menuWidget1(
                                            'My Products',
                                            'Add, edit and manage your stock items.',
                                            Icons.archive_outlined,
                                            () {
                                              Get.to(
                                                  () => StockItemsScreen({}));
                                            },
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          menuWidget1(
                                            'Finance',
                                            'Manage all your financial records.',
                                            Icons.monetization_on_outlined,
                                            () {
                                              Get.to(() =>
                                                  TransactionListScreen());
                                            },
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          menuWidget1(
                                            'Dashboard',
                                            'Full access to your account online.',
                                            Icons.web_outlined,
                                            () {
                                              Utils.urlLauncher(Utils.API_URL
                                                  .replaceAll('/api', ''));
                                            },
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          menuWidget1(
                                            'Reports',
                                            'Generate reports for your store and sales.',
                                            Icons.picture_as_pdf,
                                            () {
                                              Get.to(() =>
                                                  FinancialReportsScreen());
                                            },
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          menuWidget1(
                                            'My Account',
                                            'Full access to your account management.',
                                            Icons.person,
                                            () {
                                              Get.to(() => MenuRoute2());
                                            },
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(
                                            top: 25,
                                            bottom: 15,
                                          ),
                                          child: Text(
                                            "My Stock",
                                            style: TextStyle(
                                                color: MyColors.primary,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      },
                      childCount: 1, // 1000 list items
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return stockItemTile(stole_items[index], false);
                      },
                      childCount: stole_items.length, // 1000 list items
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle),
                      SizedBox(
                        width: 5,
                      ),
                      Text("No item is running out of stock."),
                    ],
                  ),
                ),
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
        Container(
          width: 10,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(Utils.APP_NAME,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1,
                )),
            Text("${Utils.greet()} ${user.name}.",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.start),
          ],
        ),
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
