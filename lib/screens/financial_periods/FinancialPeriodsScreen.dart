import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/FinancialPeriodModel.dart';
import '../../widget/widgets.dart';
import 'FinancialPeriodCreateScreen.dart';

class FinancialPeriodsScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  FinancialPeriodsScreen(this.params);

  @override
  State<FinancialPeriodsScreen> createState() => _FinancialPeriodsScreenState();
}

class _FinancialPeriodsScreenState extends State<FinancialPeriodsScreen> {
  List<FinancialPeriodModel> items = [];
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
    items = await FinancialPeriodModel.get_items();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Financial Periods"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => FinancialPeriodCreateScreen(FinancialPeriodModel()));
          },
          child: const Icon(Icons.add),
        ),
        body: items.isEmpty
            ? emptyListWidget("No Financial Periods found.", "Refresh", () {
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
                      title: Text(items[index].name),
                      onTap: () {
                        if (isPicker) {
                          Get.back(result: items[index]);
                        }

                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Get.to(
                              () => FinancialPeriodCreateScreen(items[index]));
                        },
                      ),
                    );
                  },
                ),
              ));
  }
}
