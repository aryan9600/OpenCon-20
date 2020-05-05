import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class SponsorCard extends StatelessWidget {

  String logoUrl;

  SponsorCard(this.logoUrl);

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Container(
      // padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal, SizeConfig.blockSizeVertical/5, SizeConfig.blockSizeHorizontal, SizeConfig.blockSizeVertical/5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.009),
            blurRadius: 2,
            offset: Offset(3, 3)
          ),
        ]
      ),
      child: Card(
        
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // elevation: 20,
        child: Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
          height: SizeConfig.blockSizeVertical*15,
          width: SizeConfig.screenWidth/4,
          child: Image.network(logoUrl, fit: BoxFit.contain),
          // CachedNetworkImage(
          //   imageUrl: logoUrl,
          //   progressIndicatorBuilder: (context, url, downloadProgress) => 
          //           CircularProgressIndicator(value: downloadProgress.progress),
          //   errorWidget: (context, url, error) => Icon(Icons.error),
          //   fit: BoxFit.contain,
          // ),
        ),
      ),
    );
  }
}