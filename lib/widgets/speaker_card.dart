import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class SpeakerCard extends StatelessWidget {

  String imgUrl;
  String name;
  String description;
  SpeakerCard({this.name, this.description, this.imgUrl});

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth/1.25,    
      height: SizeConfig.blockSizeVertical*25,
      child: Card(
        elevation: 20,
        color: Color(0xff232526),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical)
        ),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeVertical*1.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: SizeConfig.screenWidth/4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical),
                  image: DecorationImage(
                    image: NetworkImage(imgUrl),
                    fit: BoxFit.cover
                  )
                ),
              ),
              Column(
                children: <Widget>[
                  Text(name, style: TextStyle(
                    fontSize: SizeConfig.blockSizeVertical*2.7,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),),
                  Container(
                    padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal, SizeConfig.blockSizeVertical, 0, SizeConfig.blockSizeHorizontal),
                    width: SizeConfig.screenWidth/3,
                    child: Text(description, style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: SizeConfig.blockSizeVertical*2
                    ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}