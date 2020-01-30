import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/timeline_row.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).canvasColor,
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: SizeConfig.blockSizeVertical*3),
                    Container(
                      height: SizeConfig.blockSizeVertical*15,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/opencon_logo.png')
                        )
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection("events").snapshots(),
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
                                print(document['time']);
                                return new TimeLineRow(
                                  date:  document['time'].toDate().toString(),
                                  time: "12:00 AM",
                                  name: document['title'],
                                  location: document['location'],
                                );
                              }).toList(),
                            );
                        }
                      },
                    ),
                    SizedBox(height: SizeConfig.screenHeight/10,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}