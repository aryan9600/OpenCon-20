import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_con/utils/helper_functions.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/timeline_row.dart';

class TimelineScreen extends StatefulWidget {

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  
  Stream<QuerySnapshot> dayOne;
  Stream<QuerySnapshot> dayTwo;
  @override
  initState(){
    super.initState();
    dayOne = Firestore.instance.collection("dayOne").snapshots();
    dayTwo = Firestore.instance.collection("dayTwo").snapshots();
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    final help = HelperFunctions();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white10,
            bottom: TabBar(
              indicatorColor: Colors.transparent,
              isScrollable: true,
              unselectedLabelStyle: TextStyle(
                  fontFamily: "Blinker",
                  fontSize: SizeConfig.blockSizeVertical*4,
                ),
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(
                  fontFamily: "Blinker",
                  fontSize: SizeConfig.blockSizeVertical*6,
                ),
              labelColor: Color(0xff00B7D0),
              tabs: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                  child: Text("Day 1",),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*2.5),
                  child: Text("Day 2",),
                ),
              ],
            )
          ),
        ),
        body: TabBarView(
          children: [
            DayOne(events: dayOne, help: help),
            DayOne(events: dayTwo, help: help)
          ]
        )
      ),
    );
  }
}

class DayOne extends StatelessWidget {
  const DayOne({
    Key key,
    @required this.events,
    @required this.help,
  }) : super(key: key);

  final Stream<QuerySnapshot> events;
  final HelperFunctions help;

  @override
  Widget build(BuildContext context) {
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