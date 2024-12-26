import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ImageCacheHelper {
  // Function to download and cache image
  static Future<File> downloadAndCacheImage(String imageUrl) async {
    try {
      var dio = Dio();
      var response = await dio.get(imageUrl, options: Options(responseType: ResponseType.bytes));

      // Get the application's document directory to store the image
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/cached_image.jpg';

      // Save the image to the local file system
      File file = File(filePath)..writeAsBytesSync(response.data);
      return file;
    } catch (e) {
      print("Error downloading image: $e");
      return null;
    }
  }

  // Function to load the cached image (from local storage)
  static Future<Image> loadCachedImage() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/cached_image.jpg';

      File file = File(filePath);
      if (await file.exists()) {
        return Image.file(file);  // Return the cached image
      } else {
        throw 'Image not found!';
      }
    } catch (e) {
      print("Error loading cached image: $e");
      return null;
    }
  }
}

class OfflineImageExample extends StatelessWidget {
  final String imageUrl = 'https://your-cloud-storage-url/image.jpg'; // Image URL from cloud storage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Offline Image Example")),
      body: FutureBuilder<File>(
        future: ImageCacheHelper.downloadAndCacheImage(imageUrl), // Download and cache image
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return Center(child: Image.file(snapshot.data)); // Display cached image
          }

          return Center(child: Text("Failed to load image"));
        },
      ),
    );
  }
}
