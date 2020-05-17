import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/screens/chat_screen.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/speaker_card.dart';
import 'package:open_con/widgets/sponsor_card.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class AboutEventScreen extends StatefulWidget {

  static const routeName = '/about';
  @override
  _AboutEventScreenState createState() => _AboutEventScreenState();
}

class _AboutEventScreenState extends State<AboutEventScreen> {

  Stream<QuerySnapshot> speakers;
  Stream<QuerySnapshot> sponsors;
  SwiperController _speakersController = SwiperController();

  @override
  void initState() {
    super.initState();
    speakers = Firestore.instance.collection("speakers").snapshots();
    sponsors = Firestore.instance.collection("sponsors").snapshots();
  }
    
   @override
  Widget build(BuildContext context) {
    final userName = Provider.of<Auth>(context, listen: false).userName;
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
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*3),
                    child: Text('Speakers', style: TextStyle(
                      fontFamily: 'Blinker',
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.blockSizeVertical*4,
                    )),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical*2.5),
                  StreamBuilder(
                    stream: speakers,
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
                              physics: CustomScrollPhysics(),
                              duration: 1200,
                              controller: _speakersController,
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
                              // autoplayDelay: 1000,
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
                    stream: sponsors,
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
                            ),
                          ); 
                      }
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical*5,),
                  Center(
                    child: Container(
                      width: 240,
                      height: 48,
                      child: RaisedButton(
                        onPressed: (){
                          Navigator.push(
                            context, CupertinoPageRoute(builder: (context) => ChatScreen(userName: userName,)));
                        },
                        elevation: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Ask a Doubt   ', style: TextStyle(
                                fontFamily: 'Blinker',
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeVertical*2.5
                              ),), 
                            // SizedBox(width: SizeConfig.blockSizeVertical*2,),
                            Image.asset("assets/chat.png", width: 24, height: 20,)
                          ],
                        ),
                        color: Color(0xff00B7D0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
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

class CustomSimulation extends Simulation {
  final double initPosition;
  final double velocity;

  CustomSimulation({this.initPosition, this.velocity});

  @override
  double x(double time) {
    var max =
        math.max(math.min(initPosition, 0.0), initPosition + velocity * time);

    print(max.toString());

    return max;
  }

  @override
  double dx(double time) {
    print(velocity.toString());
    return velocity;
  }

  @override
  bool isDone(double time) {
    return false;
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  @override
  ScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics();
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return CustomSimulation(
      initPosition: position.pixels,
      velocity: velocity,
    );
  }
}