import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/profile_card.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:qr/qr.dart';

class ProfileScreen extends StatefulWidget {

  static const routeName = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  DocumentSnapshot userInfo;
  Stream<DocumentSnapshot> profile;
  initState(){
    super.initState();
    final _userUId = Provider.of<Auth>(context, listen: false).uIdToken;
    profile = Firestore.instance.collection("users").document(_userUId).snapshots();
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
                SizedBox(height: SizeConfig.blockSizeVertical*10,),
                GestureDetector(
                  onTap: (){
                    print('lol');
                  },
                  child: Container(
                    height: SizeConfig.blockSizeVertical*25,
                    child: PrettyQr(
                      typeNumber: 3,
                      size: SizeConfig.blockSizeVertical*25,
                      data: Provider.of<Auth>(context, listen: false).uIdToken,
                      errorCorrectLevel: QrErrorCorrectLevel.M,
                      roundEdges: true
                    )
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical*6,),
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