import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImagePickerWidget {
  final ValueNotifier<File?> selectedImageNotifier;

  ImagePickerWidget(this.selectedImageNotifier);

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImageNotifier.value = File(image.path);
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      selectedImageNotifier.value = File(image.path);
    }
  }
}
