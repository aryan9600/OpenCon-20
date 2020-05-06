import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/chat_message.dart';
import 'package:open_con/widgets/slide_transition.dart';
import 'package:provider/provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';


class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({Key key, this.userName}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin{

  final List<ChatMessage> _messages = <ChatMessage>[
    ChatMessage(
      text: "Hey there! How may I help you? ;)",
      name: "Bot",
      type: false,
    )
  ];
  final TextEditingController _textController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PanelController _pc = new PanelController();

  @override
  initState(){
    super.initState();
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
            GestureDetector(
              onTap: () => _handleSubmitted(_textController.text,),
              child: Container(
                height: 52,
                padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal,0,SizeConfig.blockSizeHorizontal*3,0),
                child: Image.asset("assets/send.png",)
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
    print("my user ${widget.userName} ss");
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      name: widget.userName,
      type: true,
    );
    setState(() {
      print("query: ${message.text}, ${message.name}, ${message.type}");
      _messages.insert(0, message);
    });
    Response(text);
  }

  Widget _scrollList(ScrollController sc){
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: ListView.separated(
        separatorBuilder: (ctx, i){
          return Container(
            child: Divider(
              indent: SizeConfig.blockSizeHorizontal*7,
              endIndent: SizeConfig.blockSizeHorizontal*7,
              color: Colors.grey,
            ),
          );
        },
        controller: sc,
        itemCount: 25,
        itemBuilder: (ctx, i){
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*8),
            title: Text('OpenCon app question pls', style: TextStyle(
              fontFamily: 'Blinker',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xff00B7D0)
            ),),
            subtitle: Text('Some generic answer hopefully long enough to fill the space', style: TextStyle(
              fontFamily: 'Blinker',
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: Color(0xff232528)
            )),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final _user = Provider.of<Auth>(context, listen: false);
    SizeConfig().init(context);
    return SafeArea(
      child: new Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: SizeConfig.blockSizeVertical*3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context, SlideRightRoute);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: <Widget>[
                            Image.asset("assets/back.png", height: 16, width: 16,),
                            Text(' Back', style: TextStyle(
                              fontFamily: 'Blinker',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('lol');
                        _pc.animatePanelToPosition(0.4);
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Center(
                    child: Text('Contact Us',
                      style: TextStyle(
                        fontFamily: 'Blinker',
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
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
            SlidingUpPanel(
              header: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*2.5, horizontal: SizeConfig.screenWidth/2.35),
                  height: 4,
                  width: SizeConfig.screenWidth/7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    shape: BoxShape.rectangle,
                    color: Colors.black,
                  ),
                ),
              ),
              controller: _pc,
              minHeight: 0,
              maxHeight: SizeConfig.screenHeight/1.05,
              snapPoint: 0.4,
              backdropEnabled: true,
              backdropColor: Colors.black,
              backdropOpacity: 0.5,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 6
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              panelBuilder: (ScrollController sc) => _scrollList(sc),
            )
          ],
        )
      ),
    );
  }
}