import 'package:flutter/material.dart';
import 'package:flutter_ui/model/StockSubCategoryModel.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';
import '../../widget/widgets.dart';
import 'StockSubCategoryCreateScreen.dart';
import 'StockSubCategoryDetailsScreen.dart';

class StockSubCategoriesScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  StockSubCategoriesScreen(this.params);

  @override
  State<StockSubCategoriesScreen> createState() =>
      _StockSubCategoriesScreenState();
}

class _StockSubCategoriesScreenState extends State<StockSubCategoriesScreen> {
  List<StockSubCategoryModel> items = [];
  bool isPicker = false;
  bool searchMode = false;

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

  String searchKeyword = "";

  myInit() async {
    if (searchKeyword.isNotEmpty) {
      items = await StockSubCategoryModel.get_items(
          where: "name LIKE '%$searchKeyword%'");
    } else {
      items = await StockSubCategoryModel.get_items(where: "1");
    }
    setState(() {});
  }

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
              : Text("Stock sub Categories"),
          actions: [
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
            SizedBox(width: 10),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Get.to(
                () => StockSubCategoryCreateScreen(StockSubCategoryModel()));
            myInit();
          },
          child: const Icon(Icons.add),
        ),
        body: items.isEmpty
            ? emptyListWidget("No Stock Categories found.", "Refresh", () {
                myInit();
              })
            : RefreshIndicator(
                onRefresh: () async {
                  myInit();
                },
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          Utils.getImageUrl(items[index].image),
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      title: Text(items[index].name),
                      onTap: () {
                        if (isPicker) {
                          Get.back(result: items[index]);
                          return;
                        }

                        Get.to(
                            () => StockSubCategoryDetailsScreen(items[index]));
                      },
                      subtitle: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        color: Utils.int_parse(items[index].earned_profit) > 0
                            ? Colors.green
                            : Colors.red,
                        child: Text(
                          "Profits/Loss: UGX ${Utils.moneyFormat(items[index].earned_profit)}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Get.to(
                              () => StockSubCategoryCreateScreen(items[index]));
                          myInit();
                        },
                      ),
                    );
                  },
                ),
              ));
  }
}
