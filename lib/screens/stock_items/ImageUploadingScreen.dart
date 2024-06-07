import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_ui/data/my_colors.dart';
import 'package:flutter_ui/model/LoggedInUser.dart';
import 'package:flutter_ui/model/ResponseModel.dart';
import 'package:flutter_ui/model/StockItemModel.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/Utils.dart';

class ImageUploadingScreen extends StatefulWidget {
  ImageUploadingScreen();

  @override
  State<ImageUploadingScreen> createState() => _ImageUploadingScreenState();
}

class _ImageUploadingScreenState extends State<ImageUploadingScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool isEdit = false;
  double photo_size = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myIit();
  }

  LoggedInUser u = LoggedInUser();

  myIit() async {
    u = await LoggedInUser.getUser();
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
                /*  SizedBox(
                  height: 15,
                ),*/
/*

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
*/

                SizedBox(
                  height: 25,
                ),

                //image picker
                Column(
                  children: [
                    Text(
                      'image size: $photo_size MB',
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
                              height: 500,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: 500,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'No image selected',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                ),
                              ),
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
                      //get image size
                      if (image_path.isNotEmpty) {
                        File file = File(image_path);
                        photo_size = file.lengthSync() / (1024 * 1024);
                        //to 4 decimal places
                        photo_size =
                            double.parse(photo_size.toStringAsFixed(2));
                        setState(() {});
                      }

                      return;
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

  final ImagePicker picker = ImagePicker();

  do_pick_image(String source) async {
    if (source.toLowerCase() == "camera") {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo == null) {
        return;
      }
      image_path = photo.path;
      setState(() {});
    } else {
      final XFile? photo = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 30,
      );
      if (photo == null) {
        return;
      }
      image_path = photo.path;
      setState(() {});
    }
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
