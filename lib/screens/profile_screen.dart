import 'dart:typed_data';

import 'package:chirp_flutter/chirp_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/backend/deliverables.dart';
import 'package:open_con/backend/user.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/profile_card.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {

  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String _appKey = DotEnv().env['CHIRP_APP_KEY'];
  String _appSecret = DotEnv().env['CHIRP_APP_SECRET'];
  String _appConfig = DotEnv().env['CHIRP_APP_CONFIG'];

  DocumentSnapshot userInfo;

  ChirpState _chirpState = ChirpState.not_created;
  Uint8List _chirpData = Uint8List(0);


  final _delivery = Deliverables();

  Future<void> _initChirp() async {
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
  void initState() {
    super.initState();
    _initChirp();
    _configureChirp();
    _startAudioProcessing();

  }

  @override
  void dispose() {
    _stopAudioProcessing();
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

  Future<void> _setChirpCallbacks() async {
    ChirpSDK.onStateChanged.listen((e) {
      setState(() {
        _chirpState = e.current;
      });
    });
    ChirpSDK.onSending.listen((e) {
      setState(() {
        _chirpData = e.payload;
      });
    });
    ChirpSDK.onSent.listen((e) {
      setState(() {
        _chirpData = e.payload;
      });
    });
    ChirpSDK.onReceived.listen((e) {
      setState(() {
        _chirpData = e.payload;
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    final _userUId = Provider.of<Auth>(context, listen: false).uIdToken;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: Color(0xff232526),
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.blockSizeVertical*10,),
                    GestureDetector(
                      onTap: (){
                        print('lol');
                        ChirpSDK.onReceived.listen((e) {
                          String deliverable = new String.fromCharCodes(e.payload);
                          print(deliverable);
                          _delivery.addUserToDeliverable(_userUId, deliverable);
                        });
                      },
                      child: Container(
                        height: SizeConfig.blockSizeVertical*25,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/qr.png')
                          )
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical*6,),
                    StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection("users").document("d1KvBfhLJm5H3PjR73qX").snapshots(),
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
                    //ProfileCard(name: 'Sanskar Jaiswal', teamName: 'Team Alpha', email: 'jaiswalsanskar087@gmail.com'),
                    SizedBox(height: SizeConfig.blockSizeVertical*6),
                    Container(
                      height: SizeConfig.blockSizeVertical*7,
                      width: SizeConfig.blockSizeHorizontal*60,
                      child: RaisedButton(
                        onPressed: (){},
                        child: Text('Logout', style: TextStyle(
                          color: Color(0xff00B7D0),
                          fontSize: SizeConfig.blockSizeVertical*3
                        )),
                        color: Color(0xff232526),
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
          ],
        ),
      ),
    );
  }
}