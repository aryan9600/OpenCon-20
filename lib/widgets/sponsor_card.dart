import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class SponsorCard extends StatelessWidget {

  String logoUrl;

  SponsorCard(this.logoUrl);

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Container(
      child: Card(
        color: Color(0xff232526),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*2)),
        elevation: 20,
        child: Container(
          height: SizeConfig.blockSizeVertical*15,
          width: SizeConfig.screenWidth/4,
          child: Image.network(logoUrl),
        ),
      ),
    );
  }
}