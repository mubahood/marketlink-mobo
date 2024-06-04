import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/EmployeeModel.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';

class EmployeeCreateScreen extends StatefulWidget {
  EmployeeModel item;

  EmployeeCreateScreen(this.item);

  @override
  State<EmployeeCreateScreen> createState() => _EmployeeCreateScreenState();
}

class _EmployeeCreateScreenState extends State<EmployeeCreateScreen> {
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
                FormBuilderTextField(
                  name: 'first_name',
                  initialValue: widget.item.first_name,
                  onChanged: (String? val) {
                    widget.item.first_name = val!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
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

                FormBuilderTextField(
                  name: 'last_name',
                  initialValue: widget.item.last_name,
                  onChanged: (String? val) {
                    widget.item.last_name = val!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
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
                  name: 'sex',
                  initialValue: widget.item.sex,
                  onChanged: (String? val) {
                    widget.item.sex = val!;
                  },
                  options: [
                    FormBuilderFieldOption(
                      value: 'Male',
                    ),
                    FormBuilderFieldOption(
                      value: 'Female',
                    ),
                    FormBuilderFieldOption(
                      value: 'Other',
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),

                FormBuilderTextField(
                  name: 'phone_number',
                  initialValue: widget.item.phone_number,
                  onChanged: (String? val) {
                    widget.item.phone_number = val!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                FormBuilderTextField(
                  name: 'phone_number_2',
                  initialValue: widget.item.phone_number_2,
                  onChanged: (String? val) {
                    widget.item.phone_number_2 = val!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Phone Number 2',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.minLength(7),
                    FormBuilderValidators.maxLength(15),
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),

                FormBuilderTextField(
                  name: 'address',
                  initialValue: widget.item.address,
                  onChanged: (String? val) {
                    widget.item.address = val!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                //dob
                FormBuilderDateTimePicker(
                  name: 'dob',
                  initialValue: widget.item.dob.isNotEmpty
                      ? DateTime.parse(widget.item.dob)
                      : null,
                  onChanged: (DateTime? val) {
                    widget.item.dob = val.toString();
                  },
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                ),

                //field for description
                SizedBox(
                  height: 15,
                ),

                FormBuilderTextField(
                  name: 'email',
                  initialValue: widget.item.email,
                  onChanged: (String? val) {
                    widget.item.email = val!;
                    widget.item.username = widget.item.email;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.email(),
                    FormBuilderValidators.minLength(3),
                    FormBuilderValidators.maxLength(45),
                  ]),
                ),

                SizedBox(
                  height: 25,
                ),

                Text(
                  "Default password is 4321",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
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
                    ),
                    FormBuilderFieldOption(
                      value: 'Inactive',
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

  void doSubmit() async {
    Utils.showLoader(false);
    setState(() {
      error = '';
    });

    ResponseModel resp = ResponseModel(
      await Utils.http_post(
        'api/${EmployeeModel.end_point}',
        widget.item.toJson(),
      ),
    );

    await EmployeeModel.get_online_items();

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
