import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_con/utils/helper_functions.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/timeline_row.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({
    Key key,
    @required this.events,
    @required this.help,
  }) : super(key: key);

  final Stream<QuerySnapshot> events;
  final HelperFunctions help;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: SizeConfig.blockSizeVertical*3),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, SizeConfig.screenWidth/2.7, SizeConfig.blockSizeVertical*2),
                child: Text('START', style: TextStyle(
                  color: Color(0xff00B7D0),
                  fontSize: SizeConfig.blockSizeVertical*3,
                  fontFamily: 'Blinker'
                ),),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: events,
                builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.hasError){
                    print('Error ${snapshot.error}');
                  }
                  switch (snapshot.connectionState){
                    case ConnectionState.waiting: return Text('Fetching');
                    default:
                      return ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: snapshot.data.documents.map((DocumentSnapshot document) {
                          return new TimeLineRow(
                            date:  help.timestampToDate(document['time']),
                            time: help.timestampToTime(document['time']),
                            name: document.documentID,
                            location: document['venue'],
                          );
                        }).toList(),
                      );
                  }
                },
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical*2, SizeConfig.screenWidth/2.7, 0),
                child: Text('END', style: TextStyle(
                  color: Color(0xff00B7D0),
                  fontSize: SizeConfig.blockSizeVertical*3,
                  fontFamily: 'Blinker'
                ),),
              ),
              SizedBox(height: SizeConfig.screenHeight/10,)
            ],
          ),
        ),
      )
    );
  }
}