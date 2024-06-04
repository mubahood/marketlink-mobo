import 'package:flutter/material.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/StockRecord.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';
import '../../widget/widgets.dart';
import 'StockRecordCreateScreen.dart';

class StockRecordDetailsScreen extends StatefulWidget {
  StockRecordModel item;

  StockRecordDetailsScreen(this.item);

  @override
  State<StockRecordDetailsScreen> createState() =>
      _StockRecordDetailsScreenState();
}

class _StockRecordDetailsScreenState extends State<StockRecordDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Stock record details #${widget.item.id}"),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: MyColors.primary,
              ),
              onPressed: () {
                Get.to(() => StockRecordCreateScreen(widget.item));
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: [
              titleDetail("Date", Utils.formatDate(widget.item.created_at)),
              titleDetail("Record Type", widget.item.type.toUpperCase()),
              titleDetail("Item", widget.item.name.toUpperCase()),
              titleDetail("Quantity",
                  "${widget.item.quantity.toUpperCase()}${widget.item.measurement_unit}"),
              titleDetail("Selling Price",
                  "UGX ${Utils.moneyFormat(widget.item.selling_price)}"),
              titleDetail("Total Sales",
                  "UGX ${Utils.moneyFormat(widget.item.total_sales)}"),
              titleDetail("Profit/Loss",
                  "UGX ${Utils.moneyFormat(widget.item.profit)}"),
              Divider(),
              titleDetail("Description", widget.item.description),
              //created_by_text
              titleDetail("Created By", widget.item.created_by_text),
              //financial_period_text
              titleDetail(
                  "Financial Period", widget.item.financial_period_text),
            ],
          ),
        ));
  }
}
