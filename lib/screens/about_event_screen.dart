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
      // backgroundColor: Color(0xffE5E5E5),
      body: SafeArea(
        child: 
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*5),
                    child: Text('Speakers', style: TextStyle(
                      fontFamily: 'Blinker',
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.blockSizeVertical*4,
                    )),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical*3),
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
                              viewportFraction: 0.6,
                              scale: 0.6,
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
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical*5,)
                ],
              ),
            ),
          )
      ),
    );
  }
}