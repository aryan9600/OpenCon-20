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
            color: Colors.grey[400].withOpacity(0.4),
            blurRadius: 7.5
          ),
        ]
      ),
      child: Card(
        color: Colors.white,
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
                        style: TextStyle(color: Colors.black)
                      ),
                      TextSpan(
                        text: ': ',
                        style: TextStyle(color: Colors.black)
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
                        style: TextStyle(color: Colors.black)
                      ),
                      TextSpan(
                        text: ': ',
                        style: TextStyle(color: Colors.black)
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
                        style: TextStyle(color: Colors.black)
                      ),
                      TextSpan(
                        text: ': ',
                        style: TextStyle(color: Colors.black)
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