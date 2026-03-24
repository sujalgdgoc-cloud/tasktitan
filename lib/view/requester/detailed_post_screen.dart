import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/image_and_text_controller.dart';

class DetailedPostScreen extends StatelessWidget {
  DetailedPostScreen({super.key});

  final DetailedPostController controller =
  Get.put(DetailedPostController());

  Widget inputField(
      TextEditingController controllerField,
      String label,
      IconData icon, {
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
          prefixIcon: Icon(icon, color: Get.theme.primaryColor),
          labelText: label,
          labelStyle:
          TextStyle(color: Get.textTheme.bodyMedium?.color),
          filled: true,
          fillColor: Get.theme.cardColor,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
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
        centerTitle: true,
        title: Text(
          "Create Request",
          style: TextStyle(
            color: Get.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Upload Cover",
                style: TextStyle(
                  color: Get.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: controller.pickerImg,
                child: Obx(
                      () => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 190,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Get.theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: controller.selectedImg.value != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
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
                          Icons.add_photo_alternate_outlined,
                          size: 45,
                          color: Get.theme.primaryColor,
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
                            padding: EdgeInsets.only(top: 12),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              inputField(
                controller.titleController,
                "Title",
                Icons.title,
              ),

              inputField(
                controller.descriptionController,
                "Description",
                Icons.description_outlined,
                maxLines: 4,
              ),

              inputField(
                controller.gitController,
                "GitHub Link",
                Icons.link,
                validator: controller.validateGitHub,
              ),

              inputField(
                controller.bidController,
                "Initial Bid",
                Icons.currency_rupee,
                validator: controller.validateBid,
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: Obx(
                      () => ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submitRequest,
                    style: ElevatedButton.styleFrom(
                      elevation: 6,
                      backgroundColor: Get.theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.send,
                            color: Colors.white),
                        const SizedBox(width: 10),
                        const Text(
                          "Submit Request",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
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