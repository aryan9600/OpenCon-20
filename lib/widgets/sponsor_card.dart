import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class SponsorCard extends StatelessWidget {

  String logoUrl;

  SponsorCard(this.logoUrl);

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Container(
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200].withOpacity(0.8),
                blurRadius: 20,
                offset: Offset(SizeConfig.blockSizeHorizontal, SizeConfig.blockSizeHorizontal)
              ),
              BoxShadow(
                color: Colors.grey[200].withOpacity(0.8),
                blurRadius: 20,
                offset: Offset(-SizeConfig.blockSizeHorizontal, -SizeConfig.blockSizeHorizontal)
              ),
            ]
          ),
      child: Card(
        
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*2)),
        // elevation: 20,
        child: Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
          height: SizeConfig.blockSizeVertical*15,
          width: SizeConfig.screenWidth/4,
          child: Image.network(logoUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}