import 'package:flutter/material.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/StockCategoryModel.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';
import '../../widget/widgets.dart';
import 'StockCategoryCreateScreen.dart';

class StockCategoryDetailsScreen extends StatefulWidget {
  StockCategoryModel item;

  StockCategoryDetailsScreen(this.item);

  @override
  State<StockCategoryDetailsScreen> createState() =>
      _StockCategoryDetailsScreenState();
}

/*


  String status = "";
  String buying_price = "";
  String selling_price = "";
  String expected_profit = "";

* *
* */
class _StockCategoryDetailsScreenState
    extends State<StockCategoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Stock category details #${widget.item.id}"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: MyColors.primary,
              ),
              onPressed: () {
                Get.to(() => StockCategoryCreateScreen(widget.item));
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              //image
              Image.network(
                Utils.getImageUrl(widget.item.image),
                width: 200,
                height: 200,
              ),
              titleDetail("Name", widget.item.name),

              Divider(),
              SizedBox(height: 10),
              titleDetail("Total Investment",
                  "UGX " + Utils.moneyFormat(widget.item.buying_price)),
              titleDetail("Total Sales",
                  "UGX " + Utils.moneyFormat(widget.item.selling_price)),

              titleDetail("Expected Profit",
                  "UGX " + Utils.moneyFormat(widget.item.expected_profit)),

              titleDetail("Earned Profit",
                  "UGX " + Utils.moneyFormat(widget.item.earned_profit)),
              Divider(),
              titleDetail("Details", (widget.item.description)),
            ],
          ),
        ));
  }
}
