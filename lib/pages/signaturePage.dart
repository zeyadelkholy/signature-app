import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:get/get.dart';

class ReviewSignaturePage extends StatelessWidget {
  final Uint8List signature;
  const ReviewSignaturePage({Key? key, required this.signature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: Color(0xffF5F5F5),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
              color: Color(0xffFF7A00)
          ),
          actions: [
            IconButton(
              onPressed: () => saveSignature(context),
              icon: const Icon(Icons.save),
              color: Color(0xffFF7A00)
            ),
          ],
          centerTitle: true,
          title: const Text('Save Signature',style: TextStyle(
              color: Color(0xffFF7A00)
          ),),

        ),
        body: Center(
          child: Image.memory(signature),
        ));
  }

  Future? saveSignature(BuildContext context) async {
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    //making signature name unique
    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time';
    print(name);

    final result = await ImageGallerySaver.saveImage(signature, name: name);
    final isSuccessful = result['isSuccess'];

    if (isSuccessful) {
      Navigator.pop(context);
      Get.snackbar('Success', 'Signature saved to device',
          backgroundColor: Colors.white, colorText: Colors.green);
    } else {
      Get.snackbar('Success', 'Signature saved to device',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
