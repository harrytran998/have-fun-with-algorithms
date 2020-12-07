import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as UI;

import 'package:flutter/services.dart';

Future<UI.Image> loadUiImage(String imageAssetPath) async {
  final ByteData data = await rootBundle.load(imageAssetPath);
  final Completer<UI.Image> completer = Completer();

  UI.decodeImageFromList(Uint8List.view(data.buffer), (UI.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

// class ImageLoader {
//   static AssetBundle getAssetBundle() {
//     if (rootBundle != null) {
//       return rootBundle;
//     } else {
//       return new NetworkAssetBundle(new Uri.directory(Uri.base.origin));
//     }
//   }

//   static Future<UI.Image> load(String url) async {
//     AssetBundle bundle = getAssetBundle();
//     ImageResource resource = bundle.loadImage(url);
//     return resource.first;
//   }
// }
