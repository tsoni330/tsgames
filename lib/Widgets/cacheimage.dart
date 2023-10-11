import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../appColor.dart';
import '../size_config.dart';

class CahImage extends StatelessWidget {

  String url;
  double? width,height;


  CahImage(this.url, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width! *
          SizeConfig.imageSizeMultiplier,
      height: height! *
          SizeConfig.imageSizeMultiplier,
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, url) =>
            CircularProgressIndicator(
              backgroundColor: ColorSystem.kprimary,
            ),
        imageBuilder:
            (context, imageprovider) =>
            Container(
              child: CircleAvatar(
                backgroundImage: imageprovider,
              ),
            ),
      ),
    );
  }
}
