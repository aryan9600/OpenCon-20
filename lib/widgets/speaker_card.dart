import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class SpeakerCard extends StatelessWidget {

  String imgUrl;
  String name;
  String description;
  String designation;
  String company;
  SpeakerCard({this.name, this.description, this.imgUrl, this.company, this.designation});

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth/1.4,    
      height: SizeConfig.screenHeight/2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*3),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[900].withOpacity(0.8),
            blurRadius: SizeConfig.blockSizeVertical*1.7,
            spreadRadius: SizeConfig.blockSizeHorizontal/3,
            offset: Offset(SizeConfig.blockSizeVertical, SizeConfig.blockSizeVertical)
          ),
          BoxShadow(
            color: Colors.grey[900].withOpacity(0.3),
            blurRadius: SizeConfig.blockSizeVertical*1.7,
            spreadRadius: SizeConfig.blockSizeHorizontal/3,
            offset: Offset(-SizeConfig.blockSizeVertical, -SizeConfig.blockSizeVertical)
          ),
        ]
      ),
      child: Card(
        color: Color(0xff232526),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*3)
        ),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeVertical*1.5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(imgUrl),
                radius: SizeConfig.blockSizeVertical*8
              ),
              Container(
                padding: EdgeInsetsDirectional.only(top: SizeConfig.blockSizeHorizontal*2),
                child: Text(name, style: TextStyle(
                  color: Color(0xff00B7D0),
                  fontSize: SizeConfig.blockSizeVertical*3,
                ),),
              ),
              Text("$designation, $company", style: TextStyle(
                color: Colors.grey[500],
                fontSize: SizeConfig.blockSizeVertical*2
              ),),
              Container(
                padding: EdgeInsetsDirectional.only(top: SizeConfig.blockSizeVertical),
                child: Text(description,textAlign: TextAlign.center, style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.blockSizeVertical*2
                ),),
              )
            ],
          )
        ),
      ),
    );
  }
}