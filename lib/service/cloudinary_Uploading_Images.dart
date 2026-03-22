import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';

class CloudinaryUploader {
  static final cloudinary = CloudinaryPublic("dx2psg6mh", "tasktitan_images",
      cache: false);

  static Future<String?> uploadImage(File imageFile) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
              imageFile.path, resourceType: CloudinaryResourceType.Image));
      return response.secureUrl;
    }
    catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }
}