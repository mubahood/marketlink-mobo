import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/screens/budget_management/budget/BudgetItemCategoriesScreen.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../model/BudgetItemCategoryModel.dart';
import '../../../model/BudgetItemModel.dart';
import '../../../model/Utils.dart';

class BudgetItemCreateScreen extends StatefulWidget {
  BudgetItemModel item;

  BudgetItemCreateScreen(this.item);

  @override
  State<BudgetItemCreateScreen> createState() => _BudgetItemCreateScreenState();
}

class _BudgetItemCreateScreenState extends State<BudgetItemCreateScreen> {
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
                    labelText: 'Name of item',
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
                FormBuilderTextField(
                  name: 'budget_item_category_text',
                  initialValue: widget.item.budget_item_category_text.isEmpty
                      ? widget.item.budget_item_category_id.toString()
                      : widget.item.budget_item_category_text,
                  onTap: () async {
                    BudgetItemCategoryModel? x = null;
                    x = await Get.to(
                        () => BudgetItemCategoriesScreen({'isPicker': true}));
                    if (x != null) {
                      widget.item.budget_item_category_id = x.id.toString();
                      widget.item.budget_item_category_text = x.name;
                      _formKey.currentState!.patchValue({
                        'budget_item_category_text': x.name,
                      });
                      setState(() {});
                    }
                  },
                  readOnly: true,
                  enableSuggestions: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Category',
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

                SizedBox(
                  height: 15,
                ),

                FormBuilderTextField(
                  name: 'unit_price',
                  initialValue: widget.item.unit_price,
                  onChanged: (String? val) {
                    widget.item.unit_price = val!;
                    try {
                      widget.item.target_amount =
                          (double.parse(widget.item.unit_price) *
                                  double.parse(widget.item.quantity))
                              .toString();
                    } catch (e) {}
                    setState(() {});
                  },
                  enableSuggestions: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.min(1)
                  ]),
                ),

                SizedBox(
                  height: 15,
                ),

                FormBuilderTextField(
                  name: 'quantity',
                  initialValue: widget.item.quantity == '0'
                      ? ''
                      : widget.item.quantity.toString(),
                  onChanged: (String? val) {
                    widget.item.quantity = val!;

                    try {
                      widget.item.target_amount =
                          (int.parse(widget.item.unit_price) *
                                  int.parse(widget.item.quantity))
                              .toString();
                    } catch (e) {}
                    setState(() {});
                  },
                  enableSuggestions: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Unit Price (UGX)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.min(50),
                  ]),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: FxText.bodySmall(
                    'Target Amount: ${Utils.moneyFormat(widget.item.target_amount)}',
                    fontSize: 10,
                    fontWeight: 800,
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                Divider(),
                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  name: 'invested_amount',
                  initialValue: widget.item.invested_amount == '0'
                      ? ''
                      : widget.item.invested_amount.toString(),
                  onChanged: (String? val) {
                    widget.item.invested_amount = val!;
                  },
                  enableSuggestions: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Amount Invested (UGX)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                FormBuilderTextField(
                  name: 'details',
                  initialValue: widget.item.details,
                  onChanged: (String? val) {
                    widget.item.details = val!;
                  },
                  autocorrect: true,
                  enableSuggestions: true,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 5,
                  minLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                  ),
                ),

                SizedBox(
                  height: 15,
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
    Utils.showLoader(false);
    setState(() {
      error = '';
    });

    Map<String, dynamic> formDataMap = {};
    widget.item.budget_program_id = '1'.toString();
    formDataMap = widget.item.toJson();
    u = await LoggedInUser.getUser();

    if (widget.item.id > 0) {
      formDataMap['created_by_id'] = u.id.toString();
    }
    formDataMap['chaned_by_id'] = u.id.toString();
    formDataMap['budget_program_id'] = '1'.toString();
    ResponseModel resp = ResponseModel(
      await Utils.http_post(
        'budget-item-create',
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
      BudgetItemModel temp = BudgetItemModel.fromJson(resp.data);
      if (temp.id > 0) {
        widget.item = temp;
        await widget.item.save();
      }
    } catch (e) {}

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
