import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/screens/reports/PdfViewer.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../model/FinancialReportModel.dart';
import '../../model/Utils.dart';

class FinancialReportCreateScreen extends StatefulWidget {
  FinancialReportModel item;

  FinancialReportCreateScreen(this.item);

  @override
  State<FinancialReportCreateScreen> createState() =>
      _FinancialReportCreateScreenState();
}

class _FinancialReportCreateScreenState
    extends State<FinancialReportCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create new employee"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),

                FormBuilderRadioGroup(
                  name: 'type',
                  initialValue: widget.item.type,
                  onChanged: (String? val) {
                    widget.item.type = val!;
                    setState(() {});
                  },
                  options: [
                    FormBuilderFieldOption(
                      value: 'Financial',
                    ),
                    FormBuilderFieldOption(
                      value: 'Inventory',
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Report Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                widget.item.type != 'Financial'
                    ? SizedBox()
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderRadioGroup(
                            name: 'include_finance_accounts',
                            initialValue: widget.item.include_finance_accounts,
                            onChanged: (String? val) {
                              widget.item.include_finance_accounts = val!;
                              setState(() {});
                            },
                            options: [
                              FormBuilderFieldOption(
                                value: 'Yes',
                              ),
                              FormBuilderFieldOption(
                                value: 'No',
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Include financial accounts?',
                              border: OutlineInputBorder(),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderRadioGroup(
                            name: 'include_finance_records',
                            initialValue: widget.item.include_finance_records,
                            onChanged: (String? val) {
                              widget.item.include_finance_records = val!;
                              setState(() {});
                            },
                            options: [
                              FormBuilderFieldOption(
                                value: 'Yes',
                              ),
                              FormBuilderFieldOption(
                                value: 'No',
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Include financial records?',
                              border: OutlineInputBorder(),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                        ],
                      ),

                widget.item.type != 'Inventory'
                    ? SizedBox()
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderRadioGroup(
                            name: 'inventory_include_categories',
                            initialValue:
                                widget.item.inventory_include_categories,
                            onChanged: (String? val) {
                              widget.item.inventory_include_categories = val!;
                              setState(() {});
                            },
                            options: [
                              FormBuilderFieldOption(
                                value: 'Yes',
                              ),
                              FormBuilderFieldOption(
                                value: 'No',
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Include inventory categories?',
                              border: OutlineInputBorder(),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderRadioGroup(
                            name: 'inventory_include_products',
                            initialValue:
                                widget.item.inventory_include_products,
                            onChanged: (String? val) {
                              widget.item.inventory_include_products = val!;
                              setState(() {});
                            },
                            options: [
                              FormBuilderFieldOption(
                                value: 'Yes',
                              ),
                              FormBuilderFieldOption(
                                value: 'No',
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Inventory include stock items?',
                              border: OutlineInputBorder(),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                        ],
                      ),

                SizedBox(
                  height: 15,
                ),

                SizedBox(
                  height: 15,
                ),
                FormBuilderRadioGroup(
                  name: 'period_type',
                  initialValue: widget.item.period_type,
                  onChanged: (String? val) {
                    widget.item.period_type = val!;
                    setState(() {});
                  },
                  options: [
                    FormBuilderFieldOption(
                      value: 'Today',
                    ),
                    FormBuilderFieldOption(
                      value: 'Yesterday',
                    ),
                    FormBuilderFieldOption(
                      value: 'Week',
                      child: Text('This week'),
                    ),
                    FormBuilderFieldOption(
                      value: 'Month',
                      child: Text('This month'),
                    ),
                    FormBuilderFieldOption(
                      value: 'Year',
                      child: Text('This financial year'),
                    ),
                    FormBuilderFieldOption(
                      value: 'Custom',
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Period range',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                widget.item.period_type != 'Custom'
                    ? SizedBox()
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderDateTimePicker(
                            name: 'start_date',
                            initialValue: widget.item.start_date.isNotEmpty
                                ? DateTime.parse(widget.item.start_date)
                                : null,
                            onChanged: (DateTime? val) {
                              widget.item.start_date = val.toString();
                            },
                            inputType: InputType.date,
                            decoration: InputDecoration(
                              labelText: 'Start date',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderDateTimePicker(
                            name: 'end_date',
                            initialValue: widget.item.start_date.isNotEmpty
                                ? DateTime.parse(widget.item.end_date)
                                : null,
                            onChanged: (DateTime? val) {
                              widget.item.end_date = val.toString();
                            },
                            inputType: InputType.date,
                            decoration: InputDecoration(
                              labelText: 'End date',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),

                //error
                error.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : Container(),

                SizedBox(
                  height: 25,
                ),
                //submit button
                ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      doSubmit();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      minimumSize: Size(double.infinity, 50),
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                    )),
                //field for description
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String error = '';

  LoggedInUser u = LoggedInUser();

  void doSubmit() async {
    Utils.showLoader(false);
    setState(() {
      error = '';
    });
    u = await LoggedInUser.getUser();
    widget.item.user_id = u.id.toString();
    widget.item.company_id = u.company_id.toString();
    widget.item.do_generate = "Yes";

    ResponseModel resp = ResponseModel(
      await Utils.http_post(
        'api/${FinancialReportModel.end_point}',
        widget.item.toJson(),
      ),
    );

    await FinancialReportModel.get_online_items();

    Utils.hideLoader();
    if (resp.code != 1) {
      setState(() {
        error = resp.message;
      });
      //toast
      Get.snackbar(
        "Error",
        resp.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    FinancialReportModel report = FinancialReportModel.fromJson(resp.data);
    if (report.id < 1) {
      Utils.toast("Failed to parse report data");
      return;
    }
    //success
    Get.snackbar(
      "Success",
      resp.message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Navigator.pop(context);
    Get.to(() => PdfViewerScreen(report.get_url(), report.type+" Report"));
  }
}
