import 'dart:typed_data';

import 'package:chirp_flutter/chirp_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String _appKey = DotEnv().env['CHIRP_APP_KEY'];
  String _appSecret = DotEnv().env['CHIRP_APP_SECRET'];
  String _appConfig = DotEnv().env['CHIRP_APP_CONFIG'];

  ChirpState _chirpState = ChirpState.not_created;
  Uint8List _chirpData = Uint8List(0);

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

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
            //  color: ThemeData.dark().canvasColor,
                color: Color(0xff232526),
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.blockSizeVertical*10,),
                    Container(
                      height: SizeConfig.blockSizeVertical*25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/qr.png')
                        )
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical*6,),
                    ProfileCard(),
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