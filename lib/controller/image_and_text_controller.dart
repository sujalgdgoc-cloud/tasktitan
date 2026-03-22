import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_titan/service/firebaseDatabase_post.dart';
import 'package:task_titan/service/picker_logic.dart';
import '../../service/cloudinary_Uploading_Images.dart';

class DetailedPostController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final gitController = TextEditingController();
  final bidController = TextEditingController();

  var selectedImg = Rx<File?>(null);
  var imageUrl = Rx<String?>(null);

  var isUploadingImage = false.obs;
  var isSubmitting = false.obs;
  Future<void> pickerImg() async {
    File? img = await ImageLogic.getImageFile();

    if (img != null) {
      selectedImg.value = img;
      isUploadingImage.value = true;

      String? url = await CloudinaryUploader.uploadImage(img);

      imageUrl.value = url;
      isUploadingImage.value = false;

      Get.snackbar("Success", "Image uploaded");
    }
  }

  Future<void> submitRequest() async {
    if (!formKey.currentState!.validate()) return;

    if (imageUrl.value == null) {
      Get.snackbar("Error", "Upload an image first");
      return;
    }

    isSubmitting.value = true;

    await RequestService().getDataFromUser(
      title: titleController.text,
      description: descriptionController.text,
      url: imageUrl.value!,
      gitlink: gitController.text,
      status: "open",
      bid: bidController.text,
    );

    isSubmitting.value = false;

    Get.snackbar("Success", "Request Submitted");

    formKey.currentState!.reset();

    titleController.clear();
    descriptionController.clear();
    gitController.clear();
    bidController.clear();

    selectedImg.value = null;
    imageUrl.value = null;
  }
  String? validateGitHub(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter GitHub link";
    }

    final githubPattern = RegExp(
      r'^(https?:\/\/)?(www\.)?github\.com\/[A-Za-z0-9_.-]+\/[A-Za-z0-9_.-]+\/?$',
    );

    if (!githubPattern.hasMatch(value)) {
      return "Enter a valid GitHub repository URL";
    }

    return null;
  }

  String? validateBid(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter bid amount";
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "Enter amount in ₹ (numbers only)";
    }

    if (int.parse(value) <= 0) {
      return "Amount must be greater than 0";
    }

    return null;
  }
}