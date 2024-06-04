import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../data/my_colors.dart';
import '../../../model/ContributionRecordModel.dart';
import '../../../model/FinancialPeriodModel.dart';
import '../../../model/StockCategoryModel.dart';
import '../../../model/StockSubCategoryModel.dart';
import '../../../model/Utils.dart';
import '../../../widget/widgets.dart';
import 'ContributionRecordCreateScreen.dart';

class ContributionRecordsScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  ContributionRecordsScreen(this.params);

  @override
  State<ContributionRecordsScreen> createState() =>
      _ContributionRecordsScreenState();
}

class _ContributionRecordsScreenState extends State<ContributionRecordsScreen> {
  List<ContributionRecordModel> items = [];

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

    if (searchKeyword.isNotEmpty) {
      items = await ContributionRecordModel.get_items(
          where: "name LIKE '%$searchKeyword%'");
    } else {
      items = await ContributionRecordModel.get_items(where: where);
    }

    total_balance = 0;
    total_paid = 0;
    items.forEach((element) {
      total_balance += int.parse(element.not_paid_amount);
      total_paid += int.parse(element.paid_amount);
    });

    setState(() {});
  }

  String filterByType = "";
  String filterText = "";
  int total_balance = 0;
  int total_paid = 0;

  String searchKeyword = "";
  bool searchMode = false;
  double box1 = Get.width / 3;
  double box2 = Get.width / 3;

  @override
  Widget build(BuildContext context) {
    box1 = Get.width / 2;
    box2 = Get.width / 4.5;

    return Scaffold(
        floatingActionButton: isPicker
            ? Container()
            : FloatingActionButton(
                onPressed: () async {
                  await Get.to(() => ContributionRecordCreateScreen(
                      ContributionRecordModel()));
                  myInit();
                },
                backgroundColor: MyColors.primary,
                foregroundColor: Colors.white,
                shape: CircleBorder(),
                child: Icon(Icons.add),
              ),
        appBar: AppBar(
          title: searchMode
              ? TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey.shade100),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    searchKeyword = value.toString();
                    myInit();
                    setState(() {});
                  },
                )
              : Text("Contribution Records"),
          actions: [
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
            PopupMenuButton(
              onSelected: (value) async {
                if (value == 1) {
                  Utils.urlLauncher(
                      'https://invetotrack.ugnews24.info/data-exports-print?id=1');
                } else if (value == 2) {
                  Utils.urlLauncher(
                      'https://invetotrack.ugnews24.info/data-exports-print?id=2');
                } else if (value == 3) {
                  Utils.urlLauncher(
                      'https://invetotrack.ugnews24.info/data-exports-print?id=3');
                }
              },
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Friends"),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Family"),
                  ),
                  const PopupMenuItem(
                    value: 3,
                    child: Text("MTK"),
                  ),
                ];
              },
            ),
            SizedBox(
              width: 15,
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
                    Row(
                      children: [
                        FxContainer(
                          child: FxText.bodySmall(
                            "Name",
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
                            "PAID (UGX)",
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
                            "Balance (UGX)",
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
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
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
                                              color: items[index].fully_paid ==
                                                      'Yes'
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            FxText(items[index].name + " : "),
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
                                                  items[index].paid_amount) +
                                              (" (${Utils.getFirtLetter(items[index].treasurer_text)})"),
                                          color: MyColors.primary,
                                          fontWeight: 700,
                                        ),
                                      ),
                                      Container(
                                        width: Get.width - (box1 + box2),
                                        child: FxText(
                                          Utils.moneyFormat(
                                              items[index].not_paid_amount),
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
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            itemDetail(
                                                'Pledged',
                                                Utils.moneyFormat(
                                                    items[index].amount)),
                                            itemDetail(
                                                'Paid',
                                                Utils.moneyFormat(
                                                    items[index].paid_amount)),
                                            itemDetail(
                                                'Not Paid',
                                                Utils.moneyFormat(items[index]
                                                    .not_paid_amount)),
                                            itemDetail(
                                                'DATE',
                                                Utils.to_date(
                                                    items[index].updated_at)),
                                            Divider(
                                              height: 1,
                                              indent: 5,
                                              endIndent: 5,
                                            ),
                                            itemDetail('Category',
                                                items[index].category_id),
                                            itemDetail('Recorded By',
                                                items[index].chaned_by_text),
                                            itemDetail(
                                                'Money Received By',
                                                (items[index]
                                                    .treasurer_text
                                                    .toString())),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                FxButton.rounded(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 20),
                                                  onPressed: () async {
                                                    String text = items[index]
                                                        .getThanks();
                                                    //copy to clipboard
                                                    await Utils.copyToClipboard(
                                                        text);
                                                  },
                                                  child: FxText(
                                                    'Copy Thanks',
                                                    color: Colors.white,
                                                  ),
                                                  backgroundColor:
                                                      Colors.green.shade800,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                FxButton.rounded(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 20),
                                                  onPressed: () async {
                                                    await Get.to(() =>
                                                        ContributionRecordCreateScreen(
                                                            items[index]));
                                                    setState(() {});
                                                    //myInit();
                                                  },
                                                  child: FxText(
                                                    'Update Record',
                                                    color: Colors.white,
                                                  ),
                                                  backgroundColor:
                                                      MyColors.primary,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            ),
                          );
                          //return stockItemTile(items[index], isPicker);
                        },
                      ),
                    ),
                    Container(
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
                              Utils.moneyFormat(total_paid.toString()),
                              color: Colors.white,
                              fontWeight: 700,
                            ),
                          ),
                          Container(
                            width: Get.width - (box1 + box2),
                            child: FxText(
                              Utils.moneyFormat(total_balance.toString()),
                              color: Colors.white,
                              fontWeight: 700,
                            ),
                          ),
                        ],
                      ),
                    ),
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
