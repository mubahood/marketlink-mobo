import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../model/FinancialPeriodModel.dart';
import '../../model/Utils.dart';

class FinancialPeriodCreateScreen extends StatefulWidget {
  FinancialPeriodModel item;

  FinancialPeriodCreateScreen(this.item);

  @override
  State<FinancialPeriodCreateScreen> createState() =>
      _FinancialPeriodCreateScreenState();
}

class _FinancialPeriodCreateScreenState
    extends State<FinancialPeriodCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Financial Period"),
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
                FormBuilderTextField(
                  name: 'name',
                  initialValue: widget.item.name,
                  onChanged: (String? val) {
                    widget.item.name = val!;
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(3),
                    FormBuilderValidators.maxLength(100),
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                FormBuilderDateRangePicker(
                  name: 'start_date',
                  initialValue: DateTimeRange(
                    start: Utils.toDate(widget.item.start_date),
                    end: Utils.toDate(widget.item.end_date),
                  ),
                  firstDate: DateTime.now().subtract(Duration(days: (2 * 365))),
                  lastDate: DateTime.now().add(Duration(days: (2 * 365))),
                  onChanged: (val) {
                    if (val == null) {
                      return;
                    }
                    widget.item.start_date = val.start.toString();
                    widget.item.end_date = val.end.toString();
                  },
                  decoration: InputDecoration(
                    labelText: 'Financial Period Date Range',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                //radio picker for status
                FormBuilderRadioGroup(
                  name: 'status',
                  initialValue: widget.item.status,
                  onChanged: (String? val) {
                    widget.item.status = val!;
                  },
                  options: [
                    FormBuilderFieldOption(
                      value: 'Active',
                      child: Text('Active'),
                    ),
                    FormBuilderFieldOption(
                      value: 'Inactive',
                      child: Text('Inactive'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                //field for description
                SizedBox(
                  height: 25,
                ),
                FormBuilderTextField(
                  name: 'description',
                  initialValue: widget.item.description,
                  onChanged: (String? val) {
                    widget.item.description = val!;
                  },
                  maxLines: 4,
                  minLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(3),
                    FormBuilderValidators.maxLength(100),
                  ]),
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
                      ResponseModel resp = ResponseModel(({
                        'code': 1,
                        'message': 'Unauthonticatased.',
                        'data': {'name': 'John Doe', 'age': '30'}
                      }));

                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      Get.defaultDialog(
                        title: "Alert",
                        middleText: "Do you want to submit?",
                        onConfirm: () {
                          Get.back();
                          doSubmit();
                        },
                        onCancel: () {},
                        textConfirm: 'Yes',
                        textCancel: 'Cancel',
                      );
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String error = '';

  void doSubmit() async {
    //validate dates
    if (widget.item.start_date.isEmpty || widget.item.end_date.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select a valid date range",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Utils.showLoader(false);
    setState(() {
      error = '';
    });

    if (widget.item.total_expenses.isEmpty) {
      widget.item.total_expenses = "0";
    }
    //total_profit
    if (widget.item.total_profit.isEmpty) {
      widget.item.total_profit = "0";
    }
    //total_sales
    if (widget.item.total_sales.isEmpty) {
      widget.item.total_sales = "0";
    }
    //total_investment
    if (widget.item.total_investment.isEmpty) {
      widget.item.total_investment = "0";
    }

    ResponseModel resp = ResponseModel(
        await Utils.http_post('api/FinancialPeriod', widget.item.toJson()));
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

    //success
    Get.snackbar(
      "Success",
      "Financial Period created successfully.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
