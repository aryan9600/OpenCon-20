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
                            height: SizeConfig.screenHeight/2.75,
                            child: Swiper(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical),
                                  child: SpeakerCard(
                                    name: snapshot.data.documents[index]['name'],
                                    description: snapshot.data.documents[index]['description'],
                                    imgUrl: snapshot.data.documents[index]['imgUrl'],
                                    company: snapshot.data.documents[index]['company'],
                                    designation: snapshot.data.documents[index]['designation'],
                                    status: snapshot.data.documents[index]['status']
                                  ),
                                );
                              },
                              viewportFraction: 0.55,
                              scale: 0.6,
                              // autoplay: true,
                              // autoplayDelay: 3000,
                            ),
                          ); 
                      }
                    },
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*3),
                    child: Text('Sponsors', style: TextStyle(
                      fontFamily: 'Blinker',
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.blockSizeVertical*4,
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
                          return Container(
                            height: SizeConfig.blockSizeHorizontal*30,
                            child: Swiper(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*3),
                                  child: SponsorCard(snapshot.data.documents[index]['logoUrl'])
                                );
                              },
                              viewportFraction: 0.35,
                              scale: 1,
                              // autoplay: true,
                              // autoplayDelay: 3000,
                            ),
                          ); 
                      }
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical*5,),
                  Center(
                    child: Container(
                      width: SizeConfig.screenWidth/1.7,
                      height: SizeConfig.blockSizeVertical*9,
                      child: RaisedButton(
                        onPressed: (){},
                        elevation: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Ask a Doubt', style: TextStyle(
                                fontFamily: 'Blinker',
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeVertical*2.5
                              ),), 
                            SizedBox(width: SizeConfig.blockSizeVertical*2,),
                            Icon(Icons.chat_bubble_outline, color: Colors.white,)
                            
                          ],
                        ),
                        color: Color(0xff00B7D0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*2),
                        ),
                      ),
                    ),
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