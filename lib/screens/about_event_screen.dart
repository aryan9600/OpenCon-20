import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/speaker_card.dart';
import 'package:open_con/widgets/sponsor_card.dart';

class AboutEventScreen extends StatefulWidget {
  @override
  _AboutEventScreenState createState() => _AboutEventScreenState();
}

class _AboutEventScreenState extends State<AboutEventScreen> {
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
                    Text('ABOUT OPENCON', style: TextStyle(
                      color: Color(0xff00B7D0),
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.blockSizeVertical*3.6,
                    )),
                    Container(
                      padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*7, SizeConfig.blockSizeVertical*3, 0, SizeConfig.blockSizeVertical*4),
                      width: SizeConfig.screenWidth/1.1,
                      child: Text("/* Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris, suspendisse sed elementum ultricies eleifend amet ultrices dui. Leo, sem elementum ultrices */", style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical*2.5,
                        color: Colors.white,
                        fontFamily: 'Blinker',
                        fontWeight: FontWeight.w500
                      ),),
                    ),
                    Text('SPEAKERS', style: TextStyle(
                      color: Color(0xff00B7D0),
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.blockSizeVertical*3.6,
                    )),
                    SizedBox(height: SizeConfig.blockSizeVertical*2.5),
                    StreamBuilder(
                      stream: Firestore.instance.collection("speakers").snapshots(),
                      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.hasError){
                          print('Error ${snapshot.error}');
                        }
                        switch(snapshot.connectionState){
                          case ConnectionState.waiting: return Text('Fetching');
                          default:
                            return Container(
                              height: SizeConfig.screenHeight/2.5,
                              child: Swiper(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  return SpeakerCard(
                                    name: snapshot.data.documents[index]['name'],
                                    description: snapshot.data.documents[index]['description'],
                                    imgUrl: snapshot.data.documents[index]['imgUrl'],
                                    company: snapshot.data.documents[index]['company'],
                                    designation: snapshot.data.documents[index]['designation'],
                                  );
                                },
                                viewportFraction: 0.69,
                                scale: 0.7,
                                // autoplay: true,
                                // autoplayDelay: 3000,
                              ),
                            ); 
                        }
                      },
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical*2),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical),
                      child: Text('SPONSORS', style: TextStyle(
                        color: Color(0xff00B7D0),
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.blockSizeVertical*3.6,
                      )),
                    ),
                    StreamBuilder(
                      stream: Firestore.instance.collection("sponsors").snapshots(),
                      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.hasError){
                          print('Error ${snapshot.error}');
                        }
                        switch(snapshot.connectionState){
                          case ConnectionState.waiting: return Text('Fetching');
                          default:
                            return GridView.count(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*6),
                              primary: false,
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: SizeConfig.blockSizeVertical*3,
                              mainAxisSpacing: SizeConfig.blockSizeVertical*2,
                              children: snapshot.data.documents.map((DocumentSnapshot document){
                                return SponsorCard(document['logoUrl']);
                              }).toList()
                            );
                        }
                      },
                    )
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