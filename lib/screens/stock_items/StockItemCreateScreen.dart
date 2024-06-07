import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/StockItemModel.dart';
import 'package:flutter_ui/model/StockSubCategoryModel.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../model/Utils.dart';
import '../stock_categories/StockSubCategoriesScreen.dart';
import 'ImageUploadingScreen.dart';

class StockItemCreateScreen extends StatefulWidget {
  StockItemModel item;

  StockItemCreateScreen(this.item);

  @override
  State<StockItemCreateScreen> createState() => _StockItemCreateScreenState();
}

class _StockItemCreateScreenState extends State<StockItemCreateScreen> {
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
        title: Text("${isEdit ? 'Updating' : 'Creating new'} stock item"),
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

                InkWell(
                    onTap: () {
                      Get.to(() => ImageUploadingScreen());
                    },
                    child: Text("TEST PHOTO UPLOAD")),
                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  name: 'stock_sub_category_text',
                  initialValue: widget.item.stock_sub_category_text,
                  readOnly: true,
                  onTap: () async {
                    StockSubCategoryModel? selected =
                        await Get.to(() => StockSubCategoriesScreen({
                              'isPicker': true,
                            }));
                    if (selected != null) {
                      widget.item.stock_sub_category_id =
                          selected.id.toString();
                      widget.item.stock_sub_category_text = selected.name;
                      _formKey.currentState!.fields['stock_sub_category_text']!
                          .didChange(selected.name);
                      setState(() {});
                    }
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Select Stock Sub Category',
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
                    labelText: 'Stock item name',
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
                //radio picker for status
                FormBuilderRadioGroup(
                  name: 'generate_sku',
                  initialValue: widget.item.generate_sku,
                  onChanged: (String? val) {
                    widget.item.generate_sku = val!;
                    setState(() {});
                  },
                  options: [
                    FormBuilderFieldOption(
                      value: 'Manual',
                    ),
                    FormBuilderFieldOption(
                      value: 'Auto',
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Generate SKU (Batch Number)',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                (widget.item.generate_sku != 'Manual')
                    ? SizedBox()
                    : Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderTextField(
                            name: 'sku',
                            initialValue: widget.item.sku,
                            onChanged: (String? val) {
                              widget.item.sku = val!;
                            },
                            enableSuggestions: true,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'ENTER SKU (Batch Number)',
                              border: OutlineInputBorder(),
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

                FormBuilderTextField(
                  name: 'buying_price',
                  initialValue: widget.item.buying_price,
                  onChanged: (String? val) {
                    widget.item.buying_price = val!;
                  },
                  enableSuggestions: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Buying price',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric()
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),

                FormBuilderTextField(
                  name: 'selling_price',
                  initialValue: widget.item.selling_price,
                  onChanged: (String? val) {
                    widget.item.selling_price = val!;
                  },
                  enableSuggestions: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Selling price',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric()
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),

                FormBuilderTextField(
                  name: 'original_quantity',
                  initialValue: widget.item.original_quantity,
                  onChanged: (String? val) {
                    widget.item.original_quantity = val!;
                  },
                  enableSuggestions: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Original quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric()
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
        'api/${StockItemModel.end_point}',
        formDataMap,
      ),
    );

    await StockItemModel.get_online_items();

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
