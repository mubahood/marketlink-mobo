import 'package:flutter/material.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/FinancialPeriodModel.dart';
import 'package:flutter_ui/model/StockCategoryModel.dart';
import 'package:flutter_ui/model/StockRecord.dart';
import 'package:flutter_ui/model/StockSubCategoryModel.dart';
import 'package:flutter_ui/screens/financial_periods/FinancialPeriodsScreen.dart';
import 'package:flutter_ui/screens/stock_categories/StockCategoriesScreen.dart';
import 'package:flutter_ui/screens/stock_categories/StockSubCategoriesScreen.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';
import '../../widget/widgets.dart';
import 'StockRecordCreateScreen.dart';
import 'StockRecordDetailsScreen.dart';

class StockRecordsScreen extends StatefulWidget {
  const StockRecordsScreen();

  @override
  State<StockRecordsScreen> createState() => _StockRecordsScreenState();
}

class _StockRecordsScreenState extends State<StockRecordsScreen> {
  List<StockRecordModel> items = [];

  @override
  void initState() {
    super.initState();
    myInit();
  }

  String where = "1";

  StockCategoryModel filterCategory = StockCategoryModel();
  StockSubCategoryModel filterSubCategory = StockSubCategoryModel();
  FinancialPeriodModel filterCycle = FinancialPeriodModel();

  myInit() async {
    if (filterByType.isNotEmpty) {
      where = " type = '$filterByType' ";
      filterText = 'Type: $filterByType,';
    } else if (filterCategory.id != 0) {
      where = " stock_category_id = '${filterCategory.id}' ";
      filterText += 'Category: ${filterCategory.name},';
    } else if (filterSubCategory.id != 0) {
      where = " stock_sub_category_id = '${filterSubCategory.id}' ";
      filterText = 'Sub Category: ${filterSubCategory.name},';
    } else if (filterCycle.id != 0) {
      where = " financial_period_id = '${filterCycle.id}' ";
      filterText = 'Cycle: ${filterCycle.name},';
    } else {
      filterText = "";
      where = " 1 ";
    }

    items = await StockRecordModel.get_items(where: where);
    totalSales = 0;
    items.forEach((element) {
      totalSales += int.parse(element.total_sales);
    });
    setState(() {});
  }

  String filterByType = "";
  String filterText = "";
  int totalSales = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Stock records"),
          actions: [
            //BUTTON FOR ADDING STOCK RECORD
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 32,
              ),
              onPressed: () {
                Get.to(() => StockRecordCreateScreen(StockRecordModel()));
              },
            ),
            //filter popup menu
            PopupMenuButton(
              onSelected: (value) async {
                if (value == 1) {
                  items.sort((a, b) => a.id.compareTo(b.id));
                  setState(() {});
                } else if (value == 2) {
                  items.sort((a, b) => b.id.compareTo(a.id));
                  setState(() {});
                } else if (value == 3) {
                  items.sort((a, b) => a.total_sales.compareTo(b.total_sales));
                  setState(() {});
                } else if (value == 4) {
                  showFilterByTypeBottomSheet(context);
                } else if (value == 5) {
                  StockCategoryModel? temp =
                      await Get.to(() => StockCategoriesScreen({
                            'isPicker': true,
                          }));
                  if (temp != null) {
                    filterCategory = temp;
                    myInit();
                    setState(() {});
                  }
                } else if (value == 6) {
                  StockSubCategoryModel? temp =
                      await Get.to(() => StockSubCategoriesScreen({
                            'isPicker': true,
                          }));
                  if (temp != null) {
                    filterSubCategory = temp;
                    myInit();
                    setState(() {});
                  }
                } else if (value == 7) {
                  FinancialPeriodModel? temp =
                      await Get.to(() => FinancialPeriodsScreen({
                            'isPicker': true,
                          }));
                  if (temp != null) {
                    filterCycle = temp;
                    myInit();
                    setState(() {});
                  }
                } else if (value == 8) {
                  items.sort((b, a) => a.total_sales.compareTo(b.total_sales));
                  setState(() {});
                }
                setState(() {});
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Sort by date (ASC)"),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Sort by date (DESC)"),
                  ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text("Sort by total sales (ASC)"),
                  ),
                  const PopupMenuItem(
                    value: 8,
                    child: Text("Sort by total sales (DESC)"),
                  ),
                  const PopupMenuItem(
                    value: 4,
                    child: Text("Filter by type"),
                  ),
                  //by category
                  const PopupMenuItem(
                    value: 5,
                    child: Text("Filter by category"),
                  ),
                  //by sub category
                  const PopupMenuItem(
                    value: 6,
                    child: Text("Filter by sub category"),
                  ),
                  //filter by cycle
                  const PopupMenuItem(
                    value: 7,
                    child: Text("Filter by cycle"),
                  ),
                ];
              },
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        /*  floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Get.to(() => StockRecordCreateScreen(StockRecordModel()));
            myInit();
          },
          child: const Icon(Icons.add),
        ),*/
        body: items.isEmpty
            ? emptyListWidget("No Stock Categories found.", "Refresh", () {
                myInit();
              })
            : RefreshIndicator(
                onRefresh: () async {
                  myInit();
                },
                child: Column(
                  children: [
                    filterText.isEmpty
                        ? const SizedBox()
                        : Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                child: Text(
                                  "${filterText}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: MyColors.primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 0,
                          );
                        },
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              dense: true,
                              title: Text(
                                items[index].name +
                                    " (${items[index].quantity} ${items[index].measurement_unit})",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onTap: () {
                                Get.to(() =>
                                    StockRecordDetailsScreen(items[index]));
                              },
                              subtitle: Row(
                                children: [
                                  Text(
                                    "${Utils.formatDate(items[index].created_at)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Utils.getContextColor(
                                          items[index].type),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      items[index].type.toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 8,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                "UGX ${Utils.moneyFormat(items[index].total_sales)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ));
                        },
                      ),
                    ),
                    //totalSales
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MyColors.primary,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Sales",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "UGX ${Utils.moneyFormat(totalSales.toString())}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }

  void showFilterByTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(child: Text("Filter by type")),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                ListTile(
                  title: const Text("All"),
                  onTap: () {
                    filterByType = "";
                    Navigator.pop(context);
                    setState(() {});
                  },
                ),
                ListTile(
                  title: const Text("Sales"),
                  onTap: () {
                    filterByType = "Sale";
                    Navigator.pop(context);
                    setState(() {});
                    myInit();
                  },
                ),
                ListTile(
                  title: const Text("Damage"),
                  onTap: () {
                    filterByType = "Damage";
                    Navigator.pop(context);
                    setState(() {});
                    myInit();
                  },
                ),
                ListTile(
                  title: const Text("Expired"),
                  onTap: () {
                    filterByType = "Expired";
                    Navigator.pop(context);
                    setState(() {});
                    myInit();
                  },
                ),
                ListTile(
                  title: const Text("Lost"),
                  onTap: () {
                    filterByType = "Lost";
                    Navigator.pop(context);
                    myInit();
                    setState(() {});
                  },
                ),
                ListTile(
                  title: const Text("Internal Use"),
                  onTap: () {
                    filterByType = "Internal Use";
                    Navigator.pop(context);
                    myInit();
                    setState(() {});
                  },
                ),
                ListTile(
                  title: const Text("Other"),
                  onTap: () {
                    filterByType = "Other";
                    Navigator.pop(context);
                    myInit();
                    setState(() {});
                  },
                ),
              ],
            ),
          );
        });
  }
}
