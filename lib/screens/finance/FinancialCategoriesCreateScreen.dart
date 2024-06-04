import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/screens/finance/FinancialCategory.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';

class FinancialCategoriesCreateScreen extends StatefulWidget {
  FinancialCategory item;

  FinancialCategoriesCreateScreen(this.item);

  @override
  State<FinancialCategoriesCreateScreen> createState() =>
      _FinancialCategoriesCreateScreenState();
}

class _FinancialCategoriesCreateScreenState
    extends State<FinancialCategoriesCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Financial Category"),
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
                //field for description
                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  name: 'name',
                  initialValue: widget.item.name,
                  onChanged: (String? val) {
                    widget.item.name = val!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(3),
                    FormBuilderValidators.maxLength(100),
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  name: 'description',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  enableSuggestions: true,
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
                  height: 15,
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
    if (_formKey.currentState!.saveAndValidate()) {
      if (widget.item.name.isEmpty) {
        setState(() {
          error = 'Name is required.';
        });
        return;
      }
    }

    Utils.showLoader(false);
    setState(() {
      error = '';
    });

    ResponseModel resp = ResponseModel(
        await Utils.http_post('api/FinancialCategory', widget.item.toJson()));
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
      resp.message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Navigator.pop(context);
  }
}
