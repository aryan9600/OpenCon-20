import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {

  
  Stream<DocumentSnapshot> playing;
  Stream<DocumentSnapshot> upvoted;
  Stream<QuerySnapshot> songs;

  @override
  void initState() {
    playing = Firestore.instance.collection("songs").document("xsFXEkWi3tvJ5CzqWhbe").snapshots();
    upvoted = Firestore.instance.collection("songs").document("upvoted").snapshots();
    songs = Firestore.instance.collection("songs").snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: SizeConfig.blockSizeVertical*8,),
              Center(
                child: Container(
                  width: SizeConfig.screenWidth/1.2,
                  height: SizeConfig.screenHeight/1.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        // spreadRadius: 12,
                        offset: Offset(0, 4)
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.015),
                        blurRadius: 4,
                        // spreadRadius: 12,
                        offset: Offset(6, 0)
                      ),
                    ]
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: NowPlayingCard(playing: playing),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: SizeConfig.screenWidth/1.2,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        // spreadRadius: 12,
                        offset: Offset(0, 4)
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.015),
                        blurRadius: 4,
                        // spreadRadius: 12,
                        offset: Offset(6, 0)
                      ),
                    ]
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                     child: UpNextCard(upvoted: upvoted),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UpNextCard extends StatelessWidget {
  const UpNextCard({
    Key key,
    @required this.upvoted,
  }) : super(key: key);

  final Stream<DocumentSnapshot> upvoted;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
     stream: upvoted,
     builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
       if(snapshot.hasError){
         print("Error: ${snapshot.error}");
       }
       switch(snapshot.connectionState){
         case ConnectionState.waiting : return Text("Fetching");
         default:
           print(snapshot.data["artists"].length);
           return Container(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                       child: Text("Next Song", style: TextStyle(
                         fontFamily: "Blinker",
                         fontSize: 20,
                       ),),
                     ),
                     SizedBox(
                       height: 7,
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 16),
                       child: Text(snapshot.data["name"], style: TextStyle(
                         fontFamily: "Blinker",
                         fontSize: 20,
                         color: Color(0xff00B7D0)
                       ),),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(left: 16),
                       child: Row(
                         children: <Widget>[
                           for(int i=0; i<snapshot.data["artists"].length; i++)
                             Text(i == snapshot.data["artists"].length-1 ? "${snapshot.data["artists"][i]}" : "${snapshot.data["artists"][i]}, ", style: TextStyle(
                               fontFamily: "Blinker",
                               fontSize: 12,
                               color: Colors.black
                             )),
                         ],
                       ),
                     ),
                   ],
                 ),
                 Padding(
                   padding: EdgeInsets.only(right: 20),
                   child: Container(
                     height: 65,
                     width: 65,
                     child: Image.network(snapshot.data["artwork"], fit: BoxFit.cover),
                   ),
                 )
               ],
             ),
           );
       }
     }
                  );
  }
}

class NowPlayingCard extends StatelessWidget {
  const NowPlayingCard({
    Key key,
    @required this.playing,
  }) : super(key: key);

  final Stream<DocumentSnapshot> playing;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: playing,
      builder: (BuildContext ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.hasError){
          print("Error: ${snapshot.error}");
        }
        switch(snapshot.connectionState){
          case ConnectionState.waiting : return Text("Fetching");
          default:
            print(snapshot.data["artists"].length);
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 12, 0, 12),
                      child: Text("Now Streaming", style: TextStyle(
                        fontFamily: "Blinker",
                        fontSize: 20
                      ),),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: SizeConfig.screenWidth/1.8,
                      width: SizeConfig.screenWidth/1.75,
                      child: Image.network(snapshot.data["artwork"], fit: BoxFit.cover,)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 0, 0),
                    child: Text(snapshot.data["name"], style: TextStyle(
                      fontFamily: "Blinker",
                      fontSize: 20,
                      color: Color(0xff00B7D0)
                    ),),
                  ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 2, 0, 0),
                      child: Row(
                        children: <Widget>[
                          for(int i=0; i<snapshot.data["artists"].length; i++)
                            Text(i == snapshot.data["artists"].length-1 ? "${snapshot.data["artists"][i]}" : "${snapshot.data["artists"][i]}, ", style: TextStyle(
                              fontFamily: "Blinker",
                              fontSize: 16,
                              color: Colors.black
                            )),
                        ],
                      ),
                    )
                ],
              ),
          );
        }
      }
    );
  }
}