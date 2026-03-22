import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/image_and_text_controller.dart';

class DetailedPostScreen extends StatelessWidget {
  DetailedPostScreen({super.key});

  final DetailedPostController controller =
  Get.put(DetailedPostController());

  Widget inputField(
      TextEditingController controllerField,
      String label, {
        int maxLines = 1,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controllerField,
        maxLines: maxLines,
        style: TextStyle(color: Get.textTheme.bodyMedium?.color),
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
          TextStyle(color: Get.textTheme.bodyMedium?.color),
          filled: true,
          fillColor: Get.theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: validator ??
                (value) {
              if (value == null || value.isEmpty) {
                return "Please enter $label";
              }
              return null;
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Create Request",
          style: TextStyle(
            color: Get.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [

              GestureDetector(
                onTap: controller.pickerImg,
                child: Obx(
                      () => Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Get.theme.cardColor,
                    ),
                    child: controller.selectedImg.value != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        controller.selectedImg.value!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          size: 40,
                          color: Get.theme.iconTheme.color,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          controller.isUploadingImage.value
                              ? "Uploading..."
                              : "Tap to upload image",
                          style: TextStyle(
                            color: Get.textTheme.bodyMedium?.color,
                          ),
                        ),
                        if (controller.isUploadingImage.value)
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child:
                            CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              inputField(controller.titleController, "Title"),

              inputField(
                controller.descriptionController,
                "Description",
                maxLines: 4,
              ),

              inputField(
                controller.gitController,
                "GitHub Link",
                validator: controller.validateGitHub,
              ),

              inputField(
                controller.bidController,
                "Initial Bid",
                validator: controller.validateBid,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                      () => ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Get.theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(40),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      "Submit Request",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}