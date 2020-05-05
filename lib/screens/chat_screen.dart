import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/chat_message.dart';
import 'package:open_con/widgets/slide_transition.dart';
import 'dart:math' as math;


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin{

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String userName = '';

  @override
  initState(){
    super.initState();
    // final user = Provider.of<Auth>(context, listen: false);
    // userName = user.userName; 
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
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)
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
                        title: Text('OpenCon app question pls', style: TextStyle(
                          fontFamily: 'Blinker',
                          fontSize: SizeConfig.blockSizeVertical*3,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff00B7D0)
                        ),),
                        subtitle: Text('Some generic answer hopefully long enough to fill the space', style: TextStyle(
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
        preferredSize: Size.fromHeight(SizeConfig.blockSizeVertical*15),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context, SlideRightRoute);
            },
            child: OverflowBox(
              minWidth: 30,
              maxWidth: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: <Widget>[
                    Image.asset("assets/back.png", height: 12, width: 12,),
                    Text(' Back', style: TextStyle(
                      fontFamily: 'Blinker',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),)
                  ],
                ),
              ),
            )
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                _showSheet();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: <Widget>[
                    Text('FAQ ', style: TextStyle(
                      fontFamily: 'Blinker',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff00B7D0)
                    ),),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Image.asset("assets/faq.png", height: 16, width: 16,),
                    ),
                  ],
                ),
              ),
            )
          ],
          flexibleSpace: Center(
            child: Container(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
              child: Text('Contact Us',
                style: TextStyle(
                  fontFamily: 'Blinker',
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                ),
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