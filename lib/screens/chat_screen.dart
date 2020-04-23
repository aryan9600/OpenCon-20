import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/chat_message.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin{

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String userName = '';

  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));


  @override
  initState(){
    super.initState();
    // final user = Provider.of<Auth>(context, listen: false);
    // userName = user.userName; 
     _controller = AnimationController(vsync: this, duration: _duration);
  }

  Widget _buildTextComposer() {
    SizeConfig().init(context);
    return Container(
        // margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: Container(
                height: SizeConfig.blockSizeVertical*12,
                padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*4),
                child: new TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration(
                    hintText: 'Ask me something!',
                    hintStyle: TextStyle(
                      fontFamily: 'Blinker',
                      fontSize: SizeConfig.blockSizeHorizontal*4
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: SizeConfig.blockSizeVertical
                      ),
                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*2)
                    )
                  ),
                ),
              ),
            ),
            new Container(
              margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3),
              decoration: BoxDecoration(
                color: Color(0xff00B7D0),
                shape: BoxShape.circle
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal/1.2,0,0,SizeConfig.blockSizeHorizontal*1.5),
                child: Transform.rotate(
                  angle: 150 * math.pi/ 90,
                  child: new IconButton(
                    icon: new Icon(Icons.send, color: Colors.white),
                    onPressed: () => _handleSubmitted(_textController.text,)),
                ),
              ),
            ),
          ],
        ),
    );
  }

  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/opencon-20-081be2339280.json").build();
    Dialogflow dialogflow =Dialogflow(authGoogle: authGoogle,language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    ChatMessage message = new ChatMessage(
      text: response.getMessage() ?? new TypeMessage(response.getListMessage()[0]).platform,
      name: "Bot",
      type: false,
    );
    setState(() {
      print("response: ${message.text},  ${message.name}, ${message.type}");
      _messages.insert(0, message);
    });
    // Tts.speak(response.getMessageResponse());
    // setState(() {
    //   _messages.insert(0, message);
    // });
  }

  void _handleSubmitted(String text) {
    if(text==""){
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please type something dumfuck')));
      return;
    }
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: "Sanskar",
      type: true,
    );
    setState(() {
      print("query: ${message.text}, ${message.name}, ${message.type}");
      _messages.insert(0, message);
    });
    Response(text);
  }
  void _showSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
            expand: false,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  boxShadow:[
                    BoxShadow(
                      offset: Offset(20, 0),
                      color: Colors.grey[700],
                      blurRadius: 20,
                      spreadRadius: 10
                    ),
                    BoxShadow(
                      offset: Offset(-20, 0),
                      color: Colors.grey[700],
                      blurRadius: 20,
                      spreadRadius: 10
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.blockSizeVertical*5),
                    topRight: Radius.circular(SizeConfig.blockSizeVertical*5,)
                  )
                ),
                child: ListView.separated(
                  separatorBuilder: (context, index){
                    if(index==0){
                      return Container(height: 0, width: 0);
                    } else {
                      return Container(
                        child: Divider(
                          indent: SizeConfig.blockSizeHorizontal*7,
                          endIndent: SizeConfig.blockSizeHorizontal*7,
                          color: Colors.grey,
                        ),
                      );
                    }
                  },
                  controller: controller,
                  itemCount: 25,
                  itemBuilder: (_, i) {
                    if(i==0){
                      return Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*2.5),
                          height: SizeConfig.blockSizeHorizontal,
                          width: SizeConfig.blockSizeVertical*7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical),
                            shape: BoxShape.rectangle,
                            color: Colors.black,
                          ),
                        ),
                      );
                    } else {
                     return ListTile(
                       contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*8),
                        title: Text('Potty khalo mera gand se', style: TextStyle(
                          fontFamily: 'Blinker',
                          fontSize: SizeConfig.blockSizeVertical*3,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff00B7D0)
                        ),),
                        subtitle: Text('Yes so yummy feed me more, i want potty in my mouyth.', style: TextStyle(
                          fontFamily: 'Blinker',
                          fontSize: SizeConfig.blockSizeVertical*2,
                          fontWeight: FontWeight.w300,
                          color: Colors.black54
                        )),
                      );
                    }
                    
                  }
                ),
              );
            },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final _user = Provider.of<Auth>(context, listen: false);
    SizeConfig().init(context);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical*10),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: Container(
            padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*3.5, SizeConfig.blockSizeVertical*2, 0, 0),
            child: Text('< Back', style: TextStyle(
              color: Colors.black,
              fontFamily: 'Blinker',
              fontSize: SizeConfig.blockSizeVertical*2.5,
              fontWeight: FontWeight.w600
            ),),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                _showSheet();
                // if (_controller.isDismissed)
                //   _controller.forward();
                // else if (_controller.isCompleted)
                //   _controller.reverse();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical*2, SizeConfig.blockSizeHorizontal*4, 0),
                child: Text('FAQ >', style: TextStyle(
                  color: Color(0xff00B7D0),
                  fontFamily: 'Blinker',
                  fontSize: SizeConfig.blockSizeVertical*3,
                  fontWeight: FontWeight.w600
                ),),
              ),
            )
          ],
          title: Container(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*4),
            child: Text('Contact Us',
              style: TextStyle(
                fontFamily: 'Blinker',
                fontSize: SizeConfig.blockSizeVertical*4,
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),
            ),
          )
        ),
      ),
      body:  Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              )),
           Container(
            // decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
      ]),
    );
  }
}