import 'package:flutter/material.dart';
import 'package:flutter_ui/screens/finance/FinancialCategory.dart';
import 'package:get/get.dart';

import '../../data/my_colors.dart';
import '../../model/FinancialPeriodModel.dart';
import '../../model/StockCategoryModel.dart';
import '../../model/StockSubCategoryModel.dart';
import '../../model/Utils.dart';
import '../../widget/widgets.dart';
import 'FinancialCategoriesCreateScreen.dart';

class FinancialCategoriesScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  FinancialCategoriesScreen(this.params);

  @override
  State<FinancialCategoriesScreen> createState() =>
      _FinancialCategoriesScreenState();
}

class _FinancialCategoriesScreenState extends State<FinancialCategoriesScreen> {
  List<FinancialCategory> items = [];

  bool isPicker = false;

  @override
  void initState() {
    super.initState();

    if (widget.params.isNotEmpty) {
      if (widget.params.containsKey('isPicker')) {
        if (widget.params['isPicker'] == true) {
          isPicker = true;
        }
      }
    }

    myInit();
  }

  String where = "1";

  StockCategoryModel filterCategory = StockCategoryModel();
  StockSubCategoryModel filterSubCategory = StockSubCategoryModel();
  FinancialPeriodModel filterCycle = FinancialPeriodModel();

  myInit() async {
    filterText = "";
    if (filterCategory.id != 0) {
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

    items = await FinancialCategory.get_items(where: where);
    totalQuantity = 0;

    if (searchKeyword.isNotEmpty) {
      items = await FinancialCategory.get_items(
          where: "name LIKE '%$searchKeyword%'");
    }

    setState(() {});
  }

  String filterByType = "";
  String filterText = "";
  int totalQuantity = 0;

  String searchKeyword = "";
  bool searchMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: searchMode
              ? TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey.shade700),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    searchKeyword = value.toString();
                    myInit();
                    setState(() {});
                  },
                )
              : Text("Financial Categories"),
          actions: [
            //button for adding new stock item
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 35,
                color: MyColors.primary,
              ),
              onPressed: () async {
                await Get.to(
                    () => FinancialCategoriesCreateScreen(FinancialCategory()));
                myInit();
              },
            ),

            IconButton(
              icon: Icon(
                searchMode ? Icons.close : Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  searchMode = !searchMode;
                });
              },
            ),
            /*PopupMenuButton(
              onSelected: (value) async {
                if (value == 1) {
                  items.sort((a, b) => a.id.compareTo(b.id));
                  setState(() {});
                } else if (value == 2) {
                  items.sort((a, b) => b.id.compareTo(a.id));
                  setState(() {});
                } else if (value == 3) {
                  items.sort((a, b) =>
                      a.current_quantity.compareTo(b.current_quantity));
                  setState(() {});
                } else if (value == 4) {
                  items.sort((a, b) =>
                      b.current_quantity.compareTo(a.current_quantity));
                  setState(() {});
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
                  setState(() {});
                }
                setState(() {});
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Sort by date (ASC)."),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Sort by date (DESC)."),
                  ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text("Sort by quantity (ASC)."),
                  ),
                  const PopupMenuItem(
                    value: 4,
                    child: Text("Sort by quantity (DESC)"),
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
            ),*/
            SizedBox(
              width: 5,
            ),
          ],
        ),
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
                          return const Divider();
                        },
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            trailing: InkWell(
                              onTap: () async {
                                await Get.to(() =>
                                    FinancialCategoriesCreateScreen(
                                        items[index]));
                                myInit();
                              },
                              child: const Icon(
                                Icons.edit,
                                color: MyColors.primary,
                              ),
                            ),
                            title: Text(items[index].name,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey.shade700,
                                )),
                            onTap: () {
                              if (isPicker) {
                                Get.back(result: items[index]);
                                return;
                              }
                            },
                          );
                        },
                      ),
                    ),
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
                            "UGX ${Utils.moneyFormat(totalQuantity.toString())}",
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
}
