import 'dart:io';
import 'package:color_hex/color_hex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

String colorToHex(Color hexCode) =>
    hexCode.convertToHex.hex!.replaceFirst("#", "");
Color hexToColor(String hexCode) => "#$hexCode".convertToColor;

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImage() async {
  try {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85, // Optional: compress image
    );

    if (image != null) {
      return File(image.path);
    }
    return null;
  } catch (e) {
    print("error response ${e.toString()}");
    return null;
  }
}

Future<File?> pickSong() async {
  try {
    final res = await Permission.audio.request();
    if (res.isGranted) {
      FilePickerResult? fileResponse = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );
      print("fileresponse while picking image");

      print(fileResponse);
      if (fileResponse != null) {
        return File(fileResponse.files.single.path!);
      }
    }
    return null;
  } catch (e) {
    print("error while picking image");
    print(e.toString());
    return null;
  }
}
