import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/ContributionRecordModel.dart';
import 'package:flutter_ui/model/EmployeeModel.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/screens/employees/EmployeesScreen.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../model/Utils.dart';

class ContributionRecordCreateScreen extends StatefulWidget {
  ContributionRecordModel item;

  ContributionRecordCreateScreen(this.item);

  @override
  State<ContributionRecordCreateScreen> createState() =>
      _ContributionRecordCreateScreenState();
}

class _ContributionRecordCreateScreenState
    extends State<ContributionRecordCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool isEdit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item.id != 0) {
      isEdit = true;
    } else {
      isEdit = false;
    }
    myIit();
  }

  LoggedInUser u = LoggedInUser();

  myIit() async {
    u = await LoggedInUser.getUser();
    widget.item.chaned_by_id = u.id.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${isEdit ? 'Updating' : 'Creating new'} Contribution Record"),
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
                  enableSuggestions: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Name of contributor',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(3),
                    FormBuilderValidators.maxLength(100),
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),
                //radio picker for status
                FormBuilderRadioGroup(
                  name: 'category',
                  initialValue: widget.item.category_id,
                  onChanged: (String? val) {
                    widget.item.category_id = val!;
                    setState(() {});
                  },
                  options: [
                    FormBuilderFieldOption(
                      value: 'Family',
                    ),
                    FormBuilderFieldOption(
                      value: 'Friend',
                    ),
                    FormBuilderFieldOption(
                      value: 'MTK',
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),
                //radio picker for status
                FormBuilderRadioGroup(
                  name: 'custom_amount',
                  initialValue: widget.item.amount,
                  onChanged: (String? val) {
                    widget.item.custom_amount = val.toString();
                    //set amount
                    if (val == 'custom') {
                      widget.item.amount = '';
                    } else {
                      widget.item.amount = val.toString();
                    }
                    setState(() {});
                    _formKey.currentState!.patchValue({
                      'amount': '',
                    });
                    setState(() {});
                  },
                  options: [
                    FormBuilderFieldOption(
                      value: '5000',
                      child: Text(
                        ('5K'),
                      ),
                    ),
                    FormBuilderFieldOption(
                      value: '10000',
                      child: Text(
                        ('10K'),
                      ),
                    ),
                    FormBuilderFieldOption(
                      value: '20000',
                      child: Text(
                        ('20K'),
                      ),
                    ),
                    FormBuilderFieldOption(
                      value: '30000',
                      child: Text(
                        ('30K'),
                      ),
                    ),
                    FormBuilderFieldOption(
                      value: '50000',
                      child: Text(
                        ('50K'),
                      ),
                    ),
                    FormBuilderFieldOption(
                      value: '100000',
                      child: Text(
                        ('100K'),
                      ),
                    ),
                    FormBuilderFieldOption(
                      value: '150000',
                      child: Text(
                        ('150K'),
                      ),
                    ),
                    FormBuilderFieldOption(
                      value: '200000',
                      child: Text('200K'),
                    ),
                    FormBuilderFieldOption(
                      value: 'custom',
                      child: Text(
                        'Manual',
                      ),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Generate SKU (Batch Number)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                (widget.item.custom_amount.toLowerCase() != 'custom')
                    ? SizedBox()
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderTextField(
                            name: 'amount',
                            initialValue: widget.item.amount,
                            onChanged: (String? val) {
                              widget.item.amount = val!;
                            },
                            enableSuggestions: true,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Amount (UGX)',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 0,
                              ),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(3),
                              FormBuilderValidators.maxLength(400),
                            ]),
                          ),
                        ],
                      ),

                SizedBox(
                  height: 15,
                ),
                //radio picker for status
                FormBuilderRadioGroup(
                  name: 'fully_paid',
                  initialValue: widget.item.fully_paid,
                  onChanged: (String? val) {
                    widget.item.fully_paid = val.toString();
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
                    labelText: 'Has Paid Fully?',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  name: 'treasurer_text',
                  initialValue: widget.item.treasurer_text,
                  readOnly: true,
                  onTap: () async {
                    EmployeeModel? u = await Get.to(
                      () => EmployeesScreen({
                        'isPicker': true,
                      }),
                    );
                    if (u != null) {
                      widget.item.treasurer_id = u.id.toString();
                      widget.item.treasurer_text = u.name;
                      _formKey.currentState!.patchValue({
                        'treasurer_text': u.name,
                      });
                      setState(() {});
                    }
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Received By',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                (widget.item.fully_paid.toLowerCase() != 'no')
                    ? SizedBox()
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderTextField(
                            name: 'paid_amount',
                            initialValue: widget.item.paid_amount,
                            onChanged: (String? val) {
                              widget.item.paid_amount = val!;
                            },
                            enableSuggestions: true,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Total Amount Paid (UGX)',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 0,
                              ),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(3),
                              FormBuilderValidators.maxLength(400),
                            ]),
                          ),
                        ],
                      ),

                SizedBox(
                  height: 12,
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
                  height: 5,
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
                      'Submit Record',
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

  void doSubmit() async {
    if (widget.item.treasurer_id.isEmpty) {
      setState(() {
        error = 'Please select a treasurer';
      });
      return;
    }

    Map<String, dynamic> formDataMap = {};
    widget.item.budget_program_id = '1'.toString();
    formDataMap = widget.item.toJson();
    u = await LoggedInUser.getUser();

    if (widget.item.id > 0) {
      formDataMap['created_by_id'] = u.id.toString();
    }
    formDataMap['chaned_by_id'] = u.id.toString();
    formDataMap['treasurer_id'] = widget.item.treasurer_id;
    formDataMap['budget_program_id'] = '1'.toString();

    Utils.showLoader(false);
    setState(() {
      error = '';
    });
    ResponseModel resp = ResponseModel(
      await Utils.http_post(
        'contribution-records-create',
        formDataMap,
      ),
    );

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

    try {
      ContributionRecordModel temp =
          ContributionRecordModel.fromJson(resp.data);
      if (temp.id > 0) {
        widget.item = temp;
        await widget.item.save();
        temp.exp = true;
        setState(() {});
      }
      Get.snackbar(
        "Success",
        resp.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      //toast failed to update local db
      Get.snackbar(
        "Error",
        "Failed to update local database",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(e);
    }

    //success

    Navigator.pop(context);
  }

  String image_path = "";

  void show_image_picker_bottom_sheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Select image from',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Camera'),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }
}
