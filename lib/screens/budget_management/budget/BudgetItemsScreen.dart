import 'package:flutter/material.dart';
import 'package:flutter_ui/model/BudgetItemModel.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../data/my_colors.dart';
import '../../../model/BudgetItemCategoryModel.dart';
import '../../../model/FinancialPeriodModel.dart';
import '../../../model/StockCategoryModel.dart';
import '../../../model/StockSubCategoryModel.dart';
import '../../../model/Utils.dart';
import '../../../widget/widgets.dart';
import 'BudgetItemCreateScreen.dart';

class BudgetItemsScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  BudgetItemsScreen(this.params);

  @override
  State<BudgetItemsScreen> createState() => _BudgetItemsScreenState();
}

class _BudgetItemsScreenState extends State<BudgetItemsScreen> {
  List<BudgetItemModel> items = [];

  bool isPicker = false;
  double box1 = Get.width / 3;
  double box2 = Get.width / 3;

  BudgetItemCategoryModel category = new BudgetItemCategoryModel();

  //target_amount
  int target_amount = 0;

  //balance
  int balance = 0;

  @override
  void initState() {
    super.initState();

    if (widget.params.isNotEmpty) {
      if (widget.params.containsKey('category')) {
        if (widget.params['category'].runtimeType == category.runtimeType) {
          category = widget.params['category'];
        }
      }
    }

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
    /* if (category.id != 0) {
      where = " budget_item_category_id = '${category.id}' ";
    } else {
      where = " 1 ";
    }*/

    target_amount = 0;
    //balance
    balance = 0;
    items = await BudgetItemModel.get_items(where: where);

    if (category.id != 0) {
      items = items
          .where((element) =>
              element.budget_item_category_id == category.id.toString())
          .toList();
    }

    totalQuantity = 0;
    items.forEach((element) {
      totalQuantity += int.parse(element.target_amount);
      target_amount += int.parse(element.target_amount);
      balance += int.parse(element.balance);
    });

    //sort by name
    items.sort((a, b) => a.name.compareTo(b.name));

    setState(() {});
  }

  String filterByType = "";
  String filterText = "";
  int totalQuantity = 0;

  String searchKeyword = "";
  bool searchMode = false;

  @override
  Widget build(BuildContext context) {
    box1 = Get.width / 2;
    box2 = Get.width / 4.5;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Get.to(() => BudgetItemCreateScreen(BudgetItemModel()));
            myInit();
          },
          backgroundColor: MyColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(Icons.add),
        ),
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
              : Text(category.id == 0
                  ? "Budget items"
                  : category.name + " Budget"),
          /*actions: [
            IconButton(
              icon: Icon(
                searchMode ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  searchMode = !searchMode;
                });
              },
            ),

            //button for adding new stock item
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 35,
                color: Colors.white,
              ),
              onPressed: () async {
                */ /*await Get.to(() =>
                    ContributionRecordCreateScreen(ContributionRecordModel()));
                myInit();*/ /*
              },
            ),

            PopupMenuButton(
              onSelected: (value) async {
                if (value == 1) {
                  items.sort((a, b) => a.id.compareTo(b.id));
                  setState(() {});
                } else if (value == 2) {
                  items.sort((a, b) => b.id.compareTo(a.id));
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
            ),
            SizedBox(
              width: 15,
            ),
          ],*/
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
                    Row(
                      children: [
                        FxContainer(
                          child: FxText.bodySmall(
                            "Category",
                            color: Colors.black,
                            fontWeight: 900,
                          ),
                          color: Colors.grey.shade200,
                          borderRadiusAll: 0,
                          width: box1,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                        ),
                        FxContainer(
                          child: FxText.bodySmall(
                            "Target Amount",
                            color: Colors.black,
                            fontWeight: 900,
                          ),
                          color: Colors.grey.shade200,
                          borderRadiusAll: 0,
                          width: box2,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                        ),
                        FxContainer(
                          child: FxText.bodySmall(
                            "Balance",
                            color: Colors.black,
                            fontWeight: 900,
                          ),
                          color: Colors.grey.shade200,
                          borderRadiusAll: 0,
                          width: Get.width - (box1 + box2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                        ),
                      ],
                    ),
                    Expanded(
                      child: true
                          ? CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          items[index].exp = !items[index].exp;
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                          ),
                                          color: index % 2 == 1
                                              ? Colors.grey.shade200
                                              : Colors.white,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  FxContainer(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          size: 12,
                                                          color: Utils.int_parse(
                                                                      items[index]
                                                                          .percentage_done) <
                                                                  50
                                                              ? Colors.red
                                                              : Utils.int_parse(
                                                                          items[index]
                                                                              .percentage_done) <
                                                                      75
                                                                  ? Colors
                                                                      .orange
                                                                      .shade400
                                                                  : Colors
                                                                      .green,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        FxText(
                                                            items[index].name +
                                                                " : "),
                                                      ],
                                                    ),
                                                    padding: EdgeInsets.only(
                                                      left: 5,
                                                    ),
                                                    width: box1,
                                                  ),
                                                  Container(
                                                    width: box2,
                                                    child: FxText(
                                                      Utils.moneyFormat(
                                                          items[index]
                                                              .target_amount),
                                                      color: MyColors.primary,
                                                      fontWeight: 700,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: Get.width -
                                                        (box1 + box2),
                                                    child: FxText(
                                                      Utils.moneyFormat(
                                                          items[index].balance),
                                                      color: MyColors.primary,
                                                      fontWeight: 700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              (!items[index].exp)
                                                  ? Container()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        itemDetail(
                                                            'quantity',
                                                            Utils.moneyFormat(
                                                                items[index]
                                                                    .unit_price)),
                                                        itemDetail(
                                                            'unit price',
                                                            Utils.moneyFormat(
                                                                items[index]
                                                                    .quantity)),
                                                        itemDetail(
                                                            'TOTAL AMOUNT',
                                                            "UGX " +
                                                                Utils.moneyFormat(
                                                                    items[index]
                                                                        .target_amount)),
                                                        Divider(
                                                          height: 1,
                                                          indent: 5,
                                                          endIndent: 5,
                                                        ),
                                                        itemDetail(
                                                            'Invested',
                                                            "UGX " +
                                                                Utils.moneyFormat(
                                                                    items[index]
                                                                        .invested_amount)),
                                                        itemDetail(
                                                            'Balance',
                                                            "UGX " +
                                                                Utils.moneyFormat(
                                                                    items[index]
                                                                        .balance)),
                                                        itemDetail(
                                                            'Percentage Done',
                                                            items[index]
                                                                    .percentage_done +
                                                                "%"),
                                                        itemDetail(
                                                            'DETAILS',
                                                            items[index]
                                                                .details),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            FxButton.rounded(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          20),
                                                              onPressed:
                                                                  () async {
                                                                await Get.to(() =>
                                                                    BudgetItemCreateScreen(
                                                                        items[
                                                                            index]));
                                                                myInit();
                                                              },
                                                              child: FxText(
                                                                'Edit Record',
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              backgroundColor:
                                                                  MyColors
                                                                      .primary,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: items.length, // 1000 list items
                                  ),
                                ),
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return Container(
                                        color: MyColors.primary,
                                        child: Row(
                                          children: [
                                            FxContainer(
                                              child: FxText(
                                                "Totals : ",
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.only(
                                                left: 5,
                                              ),
                                              width: box1,
                                            ),
                                            Container(
                                              width: box2,
                                              child: FxText(
                                                Utils.moneyFormat(
                                                    target_amount.toString()),
                                                color: Colors.white,
                                                fontWeight: 700,
                                              ),
                                            ),
                                            Container(
                                              width: Get.width - (box1 + box2),
                                              child: FxText(
                                                Utils.moneyFormat(
                                                    balance.toString()),
                                                color: Colors.white,
                                                fontWeight: 700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    childCount: 1, // 1000 list items
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  color: index % 2 == 1
                                      ? Colors.grey.shade200
                                      : Colors.white,
                                  child: Row(
                                    children: [
                                      FxContainer(
                                        child:
                                            FxText(items[index].name + " : "),
                                        padding: EdgeInsets.only(
                                          left: 5,
                                        ),
                                        width: box1,
                                      ),
                                      Container(
                                        width: box2,
                                        child: FxText(
                                          Utils.moneyFormat(
                                              items[index].target_amount),
                                          color: MyColors.primary,
                                          fontWeight: 700,
                                        ),
                                      ),
                                      Container(
                                        width: Get.width - (box1 + box2),
                                        child: FxText(
                                          Utils.moneyFormat(
                                              items[index].balance),
                                          color: MyColors.primary,
                                          fontWeight: 700,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                //return stockItemTile(items[index], isPicker);
                              },
                            ),
                    ),
/*                    Container(
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
                    ),*/
                  ],
                ),
              ));
  }

  itemDetail(String t, String s) {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        FxText.bodySmall(
          t.toUpperCase() + " : ",
          color: MyColors.primary,
          fontWeight: 900,
        ),
        Expanded(child: FxText.bodySmall(s)),
      ],
    );
  }
}
