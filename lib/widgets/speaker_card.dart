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
      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical/4),
      width: SizeConfig.screenWidth/1.3,    
      height: SizeConfig.screenHeight/4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400].withOpacity(0.4),
            blurRadius: 10
          ),
        ]
      ),
      child: Card(
        color: Colors.white,
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
                  fontFamily: 'Blinker',
                  color: Colors.black,
                  fontSize: SizeConfig.blockSizeVertical*3,
                  fontWeight: FontWeight.w600
                ),),
              ),
              Text("$designation, $company", style: TextStyle(
                color: Colors.grey[500],
                fontSize: SizeConfig.blockSizeVertical*2,
                fontFamily: 'Blinker',
                fontWeight: FontWeight.w600
              ),),
              Spacer(),
              Container(
                  padding: EdgeInsetsDirectional.only(bottom: SizeConfig.blockSizeVertical),
                  child: Text("Know More",textAlign: TextAlign.center, style: TextStyle(
                    color: Color(0xff00B7D0),
                    fontSize: SizeConfig.blockSizeVertical*2
                  ),),
                ),
              
            ],
          )
        ),
      ),
    );
  }
}