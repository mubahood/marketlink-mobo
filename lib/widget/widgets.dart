import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:get/get.dart';

import '../model/StockItemModel.dart';
import '../model/Utils.dart';
import '../screens/stock_items/StockItemDetailsScreen.dart';

Widget roundedImage(String url, double w, double h,
    {String no_image = 'assets/images/logo.png', double radius = 10}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.network(url),
  );
}

Widget ShimmerLoadingWidget(
    {double width = double.infinity,
    double height = 200,
    bool is_circle = false,
    double padding = 0.0}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: SizedBox(width: width, height: height, child: Text("Loading...")),
  );
}

Widget stockItemTile(StockItemModel item, bool isPicker) {
  return ListTile(
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: roundedImage(Utils.getImageUrl(item.image), 5, 5, radius: 10),
    ),
    title: Text(item.name),
    onTap: () {
      if (isPicker) {
        Get.back(result: item);
        return;
      }
      //StockItemDetailsScreen
      Get.to(() => StockItemDetailsScreen(item));
    },
    subtitle: Container(
      child: Column(
        //current quantity
        children: [
          Row(
            children: [
              Text(
                "Available Quantity: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                "${Utils.moneyFormat(item.current_quantity)} Units",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          //selling price
          LinearProgressIndicator(
            value: item.get_progress(),
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(MyColors.primary),
          ),
        ],
      ),
    ),
    trailing: Text(
      "UGX ${Utils.moneyFormat(item.selling_price)}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.black,
      ),
    ),
  );
}

Widget titleDetail(String title, String detail) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
            fontSize: 14,
            height: 1,
            fontWeight: FontWeight.w300,
            color: Colors.grey.shade800),
      ),
      Text(
        detail.isNotEmpty ? detail : "-",
        style:
            TextStyle(fontSize: 18, height: 1.1, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget emptyListWidget(String message, String btnMsg, Function btnAction) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        SizedBox(
          height: 15,
        ),
        CupertinoButton(
          child: Text(btnMsg),
          onPressed: () {
            btnAction();
          },
          borderRadius: BorderRadius.circular(20),
          color: MyColors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
        )
      ],
    ),
  );
}
