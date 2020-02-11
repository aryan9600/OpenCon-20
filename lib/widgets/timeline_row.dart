import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class TimeLineRow extends StatelessWidget {
  // Data for each event
  String date;
  String time;
  String name;
  String location;
  TimeLineRow({this.date, this.time, this.location, this.name});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      children: <Widget>[
        //This is the first element. It displays the date and time.
        Expanded(
          flex: 5,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(time, textAlign: TextAlign.end,),
                subtitle: Text(date, textAlign: TextAlign.end,),
              )
            ],
          ),
        ),
        // This is the second element. It's the timeline indicator
        Expanded(
          flex: 1,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: SizeConfig.blockSizeHorizontal*0.8,
                height: SizeConfig.blockSizeVertical*5.5,
                decoration: new BoxDecoration(
                  color: Color(0xff00B7D0),
                  shape: BoxShape.rectangle,
                ),
                child: Text(""),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical*2,),
              Container(
                width: SizeConfig.blockSizeVertical*1.5,
                height: SizeConfig.blockSizeVertical*1.5,
                decoration: new BoxDecoration(
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: SizeConfig.blockSizeVertical*1.2,
                      blurRadius: SizeConfig.blockSizeHorizontal,
                      offset: Offset(0, SizeConfig.blockSizeHorizontal), 
                    )
                  ],
                  color: Color(0xff00B7D0),
                  shape: BoxShape.circle,
                ),
                child: Text(""),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical*2,),
              Container(
                width: SizeConfig.blockSizeHorizontal*0.8,
                height: SizeConfig.blockSizeVertical*5.5,
                decoration: new BoxDecoration(
                  color: Color(0xff00B7D0),
                  shape: BoxShape.rectangle,
                ),
                child: Text(""),
              ),
            ],
          ),
        ),
        // This is the third element. This displays the name and the location of the event.
        Expanded(
          flex: 12,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(name, style: TextStyle(color: Color(0xff00B7D0)),),
                subtitle: Text(location),
              )
            ],
          ),
        ),
      ],
    );
  }
}