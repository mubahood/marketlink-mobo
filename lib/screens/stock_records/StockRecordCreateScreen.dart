import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/StockItemModel.dart';
import 'package:flutter_ui/screens/stock_items/StockItemsScreen.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../model/StockRecord.dart';
import '../../model/Utils.dart';

class StockRecordCreateScreen extends StatefulWidget {
  StockRecordModel item;

  StockRecordCreateScreen(this.item);

  @override
  State<StockRecordCreateScreen> createState() =>
      _StockRecordCreateScreenState();
}

class _StockRecordCreateScreenState extends State<StockRecordCreateScreen> {
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
    widget.item.created_by_id = u.id.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${isEdit ? 'Updating' : 'Creating new'} stock record"),
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
                  name: 'stock_item_text',
                  initialValue: widget.item.stock_item_text,
                  readOnly: true,
                  onTap: () async {
                    StockItemModel? selected =
                        await Get.to(() => StockItemsScreen({
                              'isPicker': true,
                            }));
                    if (selected != null) {
                      widget.item.stock_item_id = selected.id.toString();
                      widget.item.stock_item_text = selected.name;
                      _formKey.currentState!.fields['stock_item_text']!
                          .didChange(selected.name);
                      setState(() {});
                    }
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Select Stock Item',
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
                  name: 'type',
                  initialValue: widget.item.type,
                  onChanged: (String? val) {
                    widget.item.type = val!;
                    setState(() {});
                  },
                  options: [
                    FormBuilderFieldOption(
                      value: 'Sale',
                    ),
                    FormBuilderFieldOption(
                      value: 'Damage',
                    ),
                    FormBuilderFieldOption(
                      value: 'Expired',
                    ),
                    FormBuilderFieldOption(
                      value: 'Internal Use',
                    ),
                    FormBuilderFieldOption(
                      value: 'Other',
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Stock record type',
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
                  name: 'quantity',
                  initialValue: widget.item.quantity,
                  onChanged: (String? val) {
                    widget.item.quantity = val!;
                  },
                  enableSuggestions: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.min(1),
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),

                FormBuilderTextField(
                  name: 'description',
                  initialValue: widget.item.description,
                  onChanged: (String? val) {
                    widget.item.description = val!;
                  },
                  minLines: 3,
                  maxLines: 5,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Stock category description',
                    border: OutlineInputBorder(),
                  ),
                ),

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

    Map<String, dynamic> formDataMap = {};
    formDataMap = widget.item.toJson();
    u = await LoggedInUser.getUser();

    formDataMap['created_by_id'] = u.id.toString();
    ;

    if (image_path.isNotEmpty) {
      formDataMap['temp_file_field'] = 'image';
      formDataMap['photo'] =
          await dio.MultipartFile.fromFile(image_path, filename: image_path);
    }

    ResponseModel resp = ResponseModel(
      await Utils.http_post(
        'api/${StockRecordModel.end_point}',
        formDataMap,
      ),
    );

    await StockRecordModel.get_online_items();

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
    _formKey.currentState!.reset();
    _formKey.currentState!.patchValue({
      'stock_item_text': '',
      'type': '',
      'quantity': '',
      'description': '',
    });

    Get.defaultDialog(
      title: "Success",
      middleText:
          "Record created successfully. Do you want to create another record?",
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: Text("No"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.item = StockRecordModel();
            _formKey.currentState!.reset();
            setState(() {});
            Get.back();
            Get.back();
          },
          child: Text("Yes"),
        ),
      ],
    );
  }

  String image_path = "";

  do_pick_image(String source) async {}

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
                  do_pick_image("camera");
                },
                child: Text('Camera'),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  do_pick_image("gallery");
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
