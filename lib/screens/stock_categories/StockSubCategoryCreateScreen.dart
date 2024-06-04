import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/StockSubCategoryModel.dart';
import 'package:flutter_ui/screens/stock_categories/StockCategoriesScreen.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../model/StockCategoryModel.dart';
import '../../model/Utils.dart';

class StockSubCategoryCreateScreen extends StatefulWidget {
  StockSubCategoryModel item;

  StockSubCategoryCreateScreen(this.item);

  @override
  State<StockSubCategoryCreateScreen> createState() =>
      _StockSubCategoryCreateScreenState();
}

class _StockSubCategoryCreateScreenState
    extends State<StockSubCategoryCreateScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${isEdit ? 'Updating' : 'Creating new'} stock sub category"),
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
                  name: 'stock_category_text',
                  initialValue: widget.item.stock_category_text,
                  readOnly: true,
                  onTap: () async {
                    StockCategoryModel? selected =
                        await Get.to(() => StockCategoriesScreen({
                              'isPicker': true,
                            }));
                    if (selected != null) {
                      widget.item.stock_category_id = selected.id.toString();
                      widget.item.stock_category_text = selected.name;
                      _formKey.currentState!.fields['stock_category_text']!
                          .didChange(selected.name);
                      setState(() {});
                    }
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Select Stock Parent Category',
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
                  name: 'name',
                  initialValue: widget.item.name,
                  onChanged: (String? val) {
                    widget.item.name = val!;
                  },
                  enableSuggestions: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Stock sub category name',
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
                  name: 'measurement_unit',
                  initialValue: widget.item.measurement_unit,
                  onChanged: (String? val) {
                    widget.item.measurement_unit = val!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Measurement unit',
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
                  name: 'reorder_level',
                  initialValue: widget.item.reorder_level,
                  onChanged: (String? val) {
                    widget.item.reorder_level = val!;
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Reorder level',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.min(0),
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

                //image picker
                Column(
                  children: [
                    Text(
                      'Category Photo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    image_path.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(image_path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          )
                        : (isEdit && widget.item.image.isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  Utils.getImageUrl(widget.item.image),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ))
                            : Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text('No image selected'),
                                ),
                              ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //remove image button
                        image_path.isNotEmpty
                            ? ElevatedButton(
                                onPressed: () {
                                  image_path = "";
                                  setState(() {});
                                },
                                child: Text('Remove image',
                                    style: TextStyle(
                                      color: Colors.red,
                                    )),
                              )
                            : Container(),
                        SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            show_image_picker_bottom_sheet(context);
                          },
                          child: Text(
                            image_path.isNotEmpty
                                ? 'Change image'
                                : 'Select image',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

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

    if (image_path.isNotEmpty) {
      formDataMap['temp_file_field'] = 'image';
      formDataMap['photo'] =
          await dio.MultipartFile.fromFile(image_path, filename: image_path);
    }

    ResponseModel resp = ResponseModel(
      await Utils.http_post(
        'api/${StockSubCategoryModel.end_point}',
        formDataMap,
      ),
    );

    await StockSubCategoryModel.get_online_items();

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

  String image_path = "";


  do_pick_image(String source) async {

  }

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
