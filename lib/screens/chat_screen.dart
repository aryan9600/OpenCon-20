import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/chat_message.dart';
import 'dart:math' as math;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
              margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
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
                      onPressed: () => _handleSubmitted(_textController.text)),
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
      name: "Me",
      type: true,
    );
    setState(() {
      print("query: ${message.text}, ${message.name}, ${message.type}");
      _messages.insert(0, message);
    });
    Response(text);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("lol"),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            )),
        // new Divider(height: 1.0),
        new Container(
          // decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }
}