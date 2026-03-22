import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageLogic {
  File? imgFile;
  static Future<File?> getImageFile() async{
    final imgPicker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(imgPicker != null){
      return File(imgPicker.path);
    }
    else{
      return null;
    }
  }

}