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
        borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400].withOpacity(0.3),
            blurRadius: 7.5
          ),
        ]
      ),
      child: Card(
        
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical)),
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