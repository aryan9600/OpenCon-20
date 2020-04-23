import 'dart:async';
import 'dart:typed_data';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:chirp_flutter/chirp_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/backend/deliverables.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/profile_card.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {

  static const routeName = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin{

  
  String _appKey = DotEnv().env['CHIRP_APP_KEY'];
  String _appSecret = DotEnv().env['CHIRP_APP_SECRET'];
  String _appConfig = DotEnv().env['CHIRP_APP_CONFIG'];
  ChirpState _chirpState = ChirpState.not_created;
  Uint8List _chirpData = Uint8List(0);

  final _delivery = Deliverables();
  String _userID;
  Stream<DocumentSnapshot> profile;
  
  AnimationController _controller; 

  bool _started = false; 
  

  Future<void> _initChirp() async {
    print("$_appKey, $_appSecret");
    await ChirpSDK.init(_appKey, _appSecret);
  }

  Future<void> _configureChirp() async {
    await ChirpSDK.setConfig(_appConfig);
  }

  Future<void> _startAudioProcessing() async {
    await ChirpSDK.start();
  }

  Future<void> _stopAudioProcessing() async {
    await ChirpSDK.stop();
  }

  @override
  void initState(){
    super.initState();
    _userID = Provider.of<Auth>(context, listen: false).uIdToken;
    profile = Firestore.instance.collection("users").document(_userID).snapshots();
    _initChirp();
    _configureChirp();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(milliseconds: 700),
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

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(1-_controller.value)),
        shape: BoxShape.circle,
        color: Colors.transparent
      ),
    );
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
                Container(
                    height: SizeConfig.screenHeight/3.5,
                    child: AnimatedBuilder(
                      animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            _started ? _buildContainer(SizeConfig.blockSizeVertical*25 * _controller.value) : Container(height: 0 , width: 0),
                            _started ? _buildContainer(SizeConfig.blockSizeHorizontal*55 * _controller.value): Container(height: 0 , width: 0),
                            _started ? _buildContainer(SizeConfig.safeBlockHorizontal*75 * _controller.value): Container(height: 0 , width: 0),
                            Align(
                              child: BouncingWidget(
                                child: Container(
                                  height: SizeConfig.screenHeight/6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff00B7D0),
                                  ),
                                    child: Center(child: Text('Me Hungy!', style: TextStyle(
                                      fontFamily: 'Blinker',
                                      fontSize: SizeConfig.blockSizeVertical*3
                                    ),))
                                ),
                                  duration: Duration(milliseconds: 200),
                                  onPressed: (){
                                    setState(() {
                                      _started = true;
                                    });
                                    print('lol');
                                    _controller.repeat();
                                    _startAudioProcessing();
                                    ChirpSDK.onReceived.listen((e) {
                                      String deliverable = new String.fromCharCodes(e.payload);
                                      print(deliverable);
                                      _delivery.addUserToDeliverable(_userID, deliverable);
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
                                    ChirpSDK.state.then((state){
                                      if(state == ChirpState.stopped){
                                        _stopAudioProcessing();
                                      } else {
                                        return;
                                      }
                                    });
                                  },
                                ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
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
                // ProfileCard(name: 'Sanskar Jaiswal', teamName: 'Team Alpha', email: 'jaiswalsanskar087@gmail.com'),
                SizedBox(height: SizeConfig.blockSizeVertical*6),
                Container(
                  height: SizeConfig.blockSizeVertical*7,
                  width: SizeConfig.blockSizeHorizontal*60,
                  child: RaisedButton(
                    onPressed: (){
                      Provider.of<Auth>(context, listen: false).signOutGoogle();
                    },
                    child: Text('Logout', style: TextStyle(
                      color: Color(0xff00B7D0),
                      fontSize: SizeConfig.blockSizeVertical*3
                    )),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical),
                      side: BorderSide(color: Color(0xff00B7D0))
                    ),
                  ),
                )
              ],
            ),
          ),
        )

      ),
    );
  }
}
