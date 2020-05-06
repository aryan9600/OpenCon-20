import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class SpeakerCard extends StatelessWidget {

  String imgUrl;
  String name;
  String description;
  String designation;
  String company;
  bool status;
  SpeakerCard({this.name, this.description, this.imgUrl, this.company, this.designation, this.status});
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth/1.3,    
      height: SizeConfig.screenHeight/4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            // spreadRadius: 12,
            offset: Offset(4, 4)
          ),
        ]
      ),
      child: FlipCard(
        key: cardKey,
        flipOnTouch: false,
        direction: FlipDirection.HORIZONTAL,
        front: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          child: Container(
            padding: EdgeInsets.all(SizeConfig.blockSizeVertical*1.5),
            child: Stack(
              children: [
                Positioned(
                  top: SizeConfig.blockSizeVertical,
                  right: SizeConfig.blockSizeHorizontal*2,
                  child: Container(
                    height: SizeConfig.blockSizeHorizontal*4,
                    child: status == true ? Image.asset("assets/speaking.png",) : Image.asset("assets/not-speaking.png") ,
                  )
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        // child: CachedNetworkImage(
                        //   imageUrl: imgUrl,
                        //   progressIndicatorBuilder: (context, url, downloadProgress) => 
                        //           CircularProgressIndicator(value: downloadProgress.progress),
                        //   errorWidget: (context, url, error) => Icon(Icons.error),
                        // ),
                        backgroundImage: NetworkImage(imgUrl),
                        radius: 50
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.only(top: SizeConfig.blockSizeHorizontal*2),
                      child: Text(name, style: TextStyle(
                        fontFamily: 'Blinker',
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600
                      ),),
                    ),
                    Text("$designation, $company", style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontFamily: 'Blinker',
                      fontWeight: FontWeight.w600
                    ),),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        cardKey.currentState.toggleCard();
                      },
                      child: Container(
                          padding: EdgeInsetsDirectional.only(bottom: SizeConfig.blockSizeVertical),
                          child: Text("Know More",textAlign: TextAlign.center, style: TextStyle(
                            color: Color(0xff8200B7D0),
                            fontSize: 16
                          ),),
                        ),
                    ),
                  ],
                ),
              ]
            )
          ),
        ),
        back: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3),
                  child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lacus, nunc sodales viverra lectus facilisis eu risus. Dui gravida pharetra turpis mi enim tortor, sagittis proin ac. Fames vitae tortor nulla felis vitae pretium. Dui, semper enim pharetra nunc et turpis eget. Nunc mauris eget duis morbi feugiat pellentesque neque. Habitant',
                    style: TextStyle(
                      fontFamily: "Blinker",
                      fontSize: 12, 
                      color: Colors.black
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  cardKey.currentState.toggleCard();
                },
                child: Container(
                    padding: EdgeInsetsDirectional.only(bottom: SizeConfig.blockSizeVertical),
                    child: Text("Know Less",textAlign: TextAlign.center, style: TextStyle(
                      color: Color(0xff8200B7D0),
                      fontSize: 16
                    ),),
                  ),
              ),
            ],
          )
        ),
      )
    );
  }
}