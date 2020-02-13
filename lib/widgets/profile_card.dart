import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class ProfileCard extends StatelessWidget {


  String name;
  String teamName;
  String email;

  ProfileCard({this.name, this.email, this.teamName});
  
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Container(
      width: SizeConfig.screenWidth/1.2,    
      height: SizeConfig.screenHeight/4,
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
            color: Colors.grey[800].withOpacity(0.12),
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
          padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text('Profile Details', style: TextStyle(
                  color: Color(0xff00B7D0),
                  fontFamily: 'Blinker',
                  fontSize: SizeConfig.blockSizeVertical*3
                ),),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*7, SizeConfig.blockSizeVertical*2, 0, 0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical*2.3,
                      color: Colors.white
                    ),
                    children: [
                      TextSpan(
                        text: 'Name ',
                      ),
                      TextSpan(
                        text: ': ',
                      ),
                      TextSpan(
                        text: name,
                        style: TextStyle(
                          color: Color(0xff00B7D0).withOpacity(0.7)
                        )
                      )
                    ]
                  ),
                )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*7, SizeConfig.blockSizeVertical*2, 0, 0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical*2.3,
                      color: Colors.white
                    ),
                    children: [
                      TextSpan(
                        text: 'Team Name ',
                      ),
                      TextSpan(
                        text: ': ',
                      ),
                      TextSpan(
                        text: teamName,
                        style: TextStyle(
                          color: Color(0xff00B7D0).withOpacity(0.7)
                        )
                      )
                    ]
                  ),
                )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*7, SizeConfig.blockSizeVertical*2, 0, 0),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical*2.3,
                      color: Colors.white
                    ),
                    children: [
                      TextSpan(
                        text: 'Email ',
                      ),
                      TextSpan(
                        text: ': ',
                      ),
                      TextSpan(
                        text: email,
                        style: TextStyle(
                          color: Color(0xff00B7D0).withOpacity(0.7)
                        )
                      )
                    ]
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}