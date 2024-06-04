import 'package:flutter/material.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';
import '../../widget/SizeConfig.dart';
import 'FinancialRecordModel.dart';
import 'TransactionCreateScreen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Financial Records",
          color: Colors.white,
          maxLines: 2,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton.extended(
                backgroundColor: MyColors.primary,
                elevation: 10,
                onPressed: () {
                  Get.to(() => TransactionCreateScreen());
                },
                label: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: FxText(
                        "CREATE TRANSACTION",
                        fontWeight: 800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              toolbarHeight: 40,
              automaticallyImplyLeading: false,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*-------------- Build Tabs here ------------------*/
                  TabBar(
                    padding: EdgeInsets.only(bottom: 0),
                    labelPadding: EdgeInsets.only(bottom: 2, left: 8, right: 8),
                    indicatorPadding: EdgeInsets.all(0),
                    labelColor: Colors.white,
                    isScrollable: false,
                    enableFeedback: true,
                    indicator: UnderlineTabIndicator(
                        borderSide:
                            BorderSide(color: MyColors.primary, width: 4)),
                    tabs: [
                      Tab(
                          height: 30,
                          child: FxText.titleMedium(
                            "INCOME (${income.length})".toUpperCase(),
                            fontWeight: 800,
                            color: MyColors.primary,
                          )),
                      Tab(
                          height: 30,
                          child: FxText.titleMedium(
                              "EXPENSE (${expense.length})".toUpperCase(),
                              fontWeight: 800,
                              color: MyColors.primary)),
                    ],
                  )
                ],
              ),
              iconTheme: IconThemeData(color: Colors.white),
              titleSpacing: 0,
            ),
            body: TabBarView(
              children: [
                mainWidget(),
                submittedWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainWidget() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: doRefresh,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return transactionWidget(income[index]);
                },
                childCount: income.length, // 1000 list items
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget submittedWidget() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: doRefresh,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return transactionWidget(expense[index]);
                },
                childCount: expense.length, // 1000 list items
              ),
            ),
          ],
        ),
      ),
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  List<FinancialRecordModel> items = [];
  List<FinancialRecordModel> income = [];
  List<FinancialRecordModel> expense = [];

  Future<dynamic> myInit() async {
    items = await FinancialRecordModel.get_items();
    income.clear();
    expense.clear();
    items.forEach((element) {
      if (element.isIncome()) {
        income.add(element);
      } else {
        expense.add(element);
      }
    });
    setState(() {});
    return "Done";
  }

  menuItemWidget(String title, String subTitle, Function screen) {
    return InkWell(
      onTap: () => {screen()},
      child: Container(
        padding: const EdgeInsets.only(left: 0, bottom: 5, top: 20),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: MyColors.primary, width: 2),
        )),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.titleLarge(
                    title,
                    color: Colors.black,
                    fontWeight: 900,
                  ),
                  FxText.bodyLarge(
                    subTitle,
                    height: 1,
                    fontWeight: 600,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 35,
            )
          ],
        ),
      ),
    );
  }

  Widget transactionWidget(FinancialRecordModel m) {
    return InkWell(
      onTap: () {
        _showMyBottomSheetTransactionDetails(Get.context, m);
      },
      child: Column(
        children: [
          Divider(
            height: 7,
            color: Colors.white,
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodySmall(
                      Utils.to_date(m.created_at),
                      fontWeight: 700,
                      fontSize: 10,
                    ),
                    FxText.bodySmall(
                      m.financial_category_text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.grey.shade800,
                      fontWeight: 400,
                    ),
                    FxText.bodySmall(
                      '${m.description}'.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: MyColors.primary,
                      fontWeight: 700,
                    ),
                  ],
                ),
              ),
              FxText.bodyLarge(
                "UGX " + Utils.moneyFormat(m.amount),
                fontWeight: 700,
                color:
                    !m.isIncome() ? Colors.red.shade700 : Colors.green.shade700,
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          Divider(
            height: 7,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  void _showMyBottomSheetTransactionDetails(
      context, FinancialRecordModel item) {
    showModalBottomSheet(
        context: context,
        barrierColor: MyColors.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              margin: EdgeInsets.only(left: 13, right: 13, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MySize.size16),
                  topRight: Radius.circular(MySize.size16),
                  bottomLeft: Radius.circular(MySize.size16),
                  bottomRight: Radius.circular(MySize.size16),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          children: [

                            SizedBox(
                              height: 5,
                            ),
                            FxText.titleLarge(
                              item.type,
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: 700,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      minVerticalPadding: 0,
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      leading: Icon(
                        Icons.monetization_on,
                        color: MyColors.primary,
                      ),
                      title: FxText.bodyMedium(
                        'Amount',
                      ),
                      subtitle: FxText.bodyLarge(
                        "UGX ${Utils.moneyFormat(item.amount)}",
                        color: Colors.black,
                        fontWeight: 700,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      leading: Icon(
                        Icons.date_range,
                        color: MyColors.primary,
                      ),
                      title: FxText.bodyMedium(
                        'Date',
                      ),
                      subtitle: FxText.bodyLarge(
                        Utils.to_date(item.created_at),
                        color: Colors.black,
                        fontWeight: 700,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      leading: Icon(
                        Icons.info_outline,
                        color: MyColors.primary,
                      ),
                      title: FxText.bodyMedium(
                        'Category',
                      ),
                      subtitle: FxText.bodyMedium(
                        item.financial_category_text,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      leading: Icon(
                        Icons.abc,
                        color: MyColors.primary,
                      ),
                      title: FxText.bodyMedium(
                        'Details',
                      ),
                      subtitle: FxText.bodyMedium(
                        item.description,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
