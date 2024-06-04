import 'package:flutter/material.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/StockItemModel.dart';
import 'package:flutter_ui/screens/stock_items/StockItemCreateScreen.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';
import '../../widget/widgets.dart';

class StockItemDetailsScreen extends StatefulWidget {
  StockItemModel item;

  StockItemDetailsScreen(this.item);

  @override
  State<StockItemDetailsScreen> createState() => _StockItemDetailsScreenState();
}

/*




  String created_by_text = "";
  String barcode = "";
  String gallery = "";

* *
* */
class _StockItemDetailsScreenState extends State<StockItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Stock item details #${widget.item.id}"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: MyColors.primary,
              ),
              onPressed: () {
                Get.to(() => StockItemCreateScreen(widget.item));
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
              titleDetail("SKU", widget.item.sku),
              titleDetail("Category",
                  "${widget.item.stock_category_text}, ${widget.item.stock_sub_category_text}"),
              Divider(),
              SizedBox(height: 10),
              titleDetail("Buying price",
                  "UGX " + Utils.moneyFormat(widget.item.buying_price)),
              titleDetail("Selling price",
                  "UGX " + Utils.moneyFormat(widget.item.selling_price)),
              titleDetail("Original quantity", widget.item.original_quantity),
              titleDetail("Current quantity", widget.item.current_quantity),
              Divider(),
              titleDetail("Date", Utils.formatDate(widget.item.created_at)),
              titleDetail("Description", (widget.item.description)),
              titleDetail("Created by", (widget.item.created_by_text)),
            ],
          ),
        ));
  }
}
