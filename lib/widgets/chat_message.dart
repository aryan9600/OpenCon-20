import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    SizeConfig().init(context);
    return <Widget>[
      new Container(
        // margin: const EdgeInsets.only(right: 10.0),
        child: new CircleAvatar(
          backgroundColor: Color(0xff00B7D0),
          radius: 25,
          child: new Image.asset("assets/opencon_logo.png", fit: BoxFit.contain, width: 18,)
        ),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Bubble(
              child: Container(
                child: Text(text, style: TextStyle(fontFamily: 'Blinker', color: Colors.white),),
                width: text.length>25?SizeConfig.screenWidth/2:null,
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal),
              ),
              margin: BubbleEdges.fromLTRB(SizeConfig.blockSizeHorizontal, SizeConfig.blockSizeVertical*2, 0, 0),
              // padding: BubbleEdges.fromLTRB(SizeConfig.blockSizeHorizontal*4, SizeConfig.blockSizeHorizontal*4, 0, SizeConfig.blockSizeHorizontal*4,),
              color: Color(0xff414141),
              radius: Radius.circular(SizeConfig.blockSizeVertical*2),
              nip: BubbleNip.leftTop,
              nipWidth: SizeConfig.blockSizeHorizontal,
              nipHeight: SizeConfig.blockSizeHorizontal*3,
            )
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    SizeConfig().init(context);
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Bubble(
              child: Container(
                width: text.length>25?SizeConfig.screenWidth/2:null,
                child: Text(
                  text, 
                  style: TextStyle(fontFamily: 'Blinker', color: Colors.white), 
                  textAlign: TextAlign.right,
                ),
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal),
              ),
              margin: BubbleEdges.fromLTRB(0, SizeConfig.blockSizeVertical*2, 0, 0),
              color: Color(0xff414141),
              radius: Radius.circular(SizeConfig.blockSizeVertical*2),
              nip: BubbleNip.rightTop,
              nipWidth: SizeConfig.blockSizeHorizontal,
              nipHeight: SizeConfig.blockSizeHorizontal*3,
            )
          ],
        ),
      ),
  
      new Container(
        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal),
        child: new CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xff00B7D0),
          child: new Text(this.name[0], style: TextStyle(color: Colors.white, fontFamily: 'Blinker', fontSize: 20))
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new Container(
      margin:  EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*2),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}