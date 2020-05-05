import 'dart:async';
import 'dart:typed_data';
import 'package:chirp_flutter/chirp_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/backend/deliverables.dart';
import 'package:open_con/screens/auth_screen.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/profile_card.dart';
import 'package:provider/provider.dart';

import '../utils/size_config.dart';


class ProfileScreen extends StatefulWidget {

  static const routeName = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{

  
  String _appKey = DotEnv().env['CHIRP_APP_KEY'];
  String _appSecret = DotEnv().env['CHIRP_APP_SECRET'];
  String _appConfig = DotEnv().env['CHIRP_APP_CONFIG'];
  ChirpState _chirpState = ChirpState.not_created;
  Uint8List _chirpData = Uint8List(0);

  final _delivery = Deliverables();
  Auth _user;
  Stream<DocumentSnapshot> profile;
  
  AnimationController _controller; 
  Animation<Offset> _offsetAnimation;

  bool _started = false; 
  double _bottom = 10;
  

  Future<void> _initChirp() async {
    print("$_appKey, $_appSecret");
    await ChirpSDK.init(_appKey, _appSecret);
  }

  Future<void> _configureChirp() async {
    await ChirpSDK.setConfig(_appConfig);
  }

  Future<void> _startAudioProcessing() async {
    print('started this shit');
    await ChirpSDK.start();
  }

  Future<void> _stopAudioProcessing() async {
    await ChirpSDK.stop();
  }

  @override
  void initState(){
    super.initState();
    _user = Provider.of<Auth>(context, listen: false);
    profile = Firestore.instance.collection("users").document(_user.uIdToken).snapshots();
    _initChirp();
    _configureChirp();
    _startAudioProcessing();

    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _stopAudioProcessing();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopAudioProcessing();
    } else if (state == AppLifecycleState.resumed) {
      _startAudioProcessing();
    }
  }

  void scanStuff(String userID, String email, Deliverables help){
    _startAudioProcessing();
    ChirpSDK.onReceived.listen((e) {
      String deliverable = new String.fromCharCodes(e.payload);
      print(deliverable);
      help.addUserToDeliverable(userID, deliverable, email);
      setState(() {
        _started = false;
      });
      _stopAudioProcessing();
    });
    Future.delayed(Duration(seconds: 10), (){
      setState(() {
        _started = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: SizeConfig.blockSizeVertical*5,),
                StreamBuilder<DocumentSnapshot>(
                  stream: profile,
                  builder: (ctx, snapshot){
                    if(snapshot.hasError){
                      print('Error ${snapshot.error}');
                    }
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting: return Text('Fetching');
                      default:
                        print(snapshot.data['name']);
                        return ProfileCard(name: snapshot.data['name'], teamName: snapshot.data['teamName'], email: snapshot.data['email']);
                    }
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical*5,),
                Stack(
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 235,
                      decoration: BoxDecoration(
                        color: Color(0xffC4C4C4),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(70)
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      // top: 0,
                      bottom: _started ? 110 : 10,
                      left: SizeConfig.blockSizeHorizontal*2,
                      child: GestureDetector(
                        onVerticalDragUpdate: (drag){
                          setState(() {
                            print('lol');
                            _started = true;
                            scanStuff(_user.uIdToken, _user.userEmail, _delivery);
                          });
                        },
                        // onTap: (){
                        //   setState(() {
                        //     print('lol');
                        //     _started = true;
                            
                        //     // _top = SizeConfig.blockSizeVertical/5;
                        //   });
                        // },
                        child: Center(
                          child: Container(
                            child: Image.asset('assets/volume.png'),
                            width: 110,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical*2),
                Text('Slide the button to scan', style: TextStyle(
                      color: Color(0xff00B7D0),
                      fontSize: 16,
                      fontFamily: 'Blinker'
                  )),
                // ProfileCard(name: 'Sanskar Jaiswal', teamName: 'Team Alpha', email: 'jaiswalsanskar087@gmail.com'),
                SizedBox(height: SizeConfig.blockSizeVertical*4),
                GestureDetector(
                    onTap: (){
                      Provider.of<Auth>(context, listen: false).signOutGoogle();
                      Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
                    },
                    child: Text('Logout', style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xff00B7D0),
                      color: Color(0xff00B7D0),
                      fontSize: 16,
                      fontFamily: 'Blinker',
                      fontWeight: FontWeight.w500
                  )),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}