import 'package:flutter/material.dart';
import 'package:flutter_ui/model/FinancialReportModel.dart';
import 'package:get/get.dart';

import '../../widget/widgets.dart';
import 'FinancialReportCreateScreen.dart';
import 'PdfViewer.dart';

class FinancialReportsScreen extends StatefulWidget {
  const FinancialReportsScreen();

  @override
  State<FinancialReportsScreen> createState() => _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends State<FinancialReportsScreen> {
  List<FinancialReportModel> items = [];

  @override
  void initState() {
    super.initState();
    myInit();
  }

  myInit() async {
    items = await FinancialReportModel.get_items();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Financial Reports"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Get.to(
                () => FinancialReportCreateScreen(FinancialReportModel()));
            myInit();
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
                      title: Text(items[index].type + " Report"),
                      subtitle: Text(
                          'From: ${items[index].start_date} To: ${items[index].end_date}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          )),
                      onTap: () {
                        Get.to(() => PdfViewerScreen(items[index].get_url(),
                            '${items[index].type} Report'));
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Get.to(
                              () => FinancialReportCreateScreen(items[index]));
                          myInit();
                        },
                      ),
                    );
                  },
                ),
              ));
  }
}
