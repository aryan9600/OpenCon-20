import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_con/screens/timeline.dart';
import 'package:open_con/utils/helper_functions.dart';
import 'package:open_con/utils/size_config.dart';

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
            TimeLine(events: dayOne, help: help),
            TimeLine(events: dayTwo, help: help)
          ]
        )
      ),
    );
  }
}

