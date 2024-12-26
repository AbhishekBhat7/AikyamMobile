import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OfflineImageExample extends StatelessWidget {
  final String imageUrl = 'https://your-cloud-storage-url/image.jpg'; // Cloud image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Offline Image Example")),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          // The image will be cached and accessible offline
        ),
      ),
    );
  }
}
