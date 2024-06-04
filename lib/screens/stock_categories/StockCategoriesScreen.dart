import 'package:flutter/material.dart';
import 'package:flutter_ui/model/StockCategoryModel.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';
import '../../widget/widgets.dart';
import 'StockCategoryCreateScreen.dart';
import 'StockCategoryDetailsScreen.dart';

class StockCategoriesScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  StockCategoriesScreen(this.params);

  @override
  State<StockCategoriesScreen> createState() => _StockCategoriesScreenState();
}

class _StockCategoriesScreenState extends State<StockCategoriesScreen> {
  List<StockCategoryModel> items = [];

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

  myInit() async {
    items = await StockCategoryModel.get_items();
    items.sort((a, b) => a.name.compareTo(b.name));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Stock Categories"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Get.to(() => StockCategoryCreateScreen(StockCategoryModel()));
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
                        Get.to(() => StockCategoryDetailsScreen(items[index]));
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
                              () => StockCategoryCreateScreen(items[index]));
                          myInit();
                        },
                      ),
                    );
                  },
                ),
              ));
  }
}
