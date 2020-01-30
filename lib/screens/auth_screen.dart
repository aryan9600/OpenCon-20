// The Login/SignUp screen.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/screens/register_screen.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';


class AuthScreen extends StatefulWidget {
	@override
	_AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

	StreamSubscription _subs;

	@override
  void initState() {
		_initDeepLinkListener();	
	  super.initState();
  }

	@override
  void dispose() {
    _disposeDeepLinkListener();
		super.dispose();
  }

	void _initDeepLinkListener() async {
    _subs = getLinksStream().listen((String link) {
      _checkDeepLink(link);
    }, cancelOnError: true);
  }

	void _checkDeepLink(String link) {
    if (link != null) {
			print('yes pls');
			print(link);
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      Provider.of<Auth>(context, listen: false).loginWithGitHub(code)
        .then((firebaseUser) {
          print("LOGGED IN AS: " + firebaseUser.displayName);
        }).catchError((e) {
          print("LOGIN ERROR: " + e.toString());
        });
    }
		else{
			print('not found ');
		}
  }

	void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs.cancel();
      _subs = null;
    }
  }

	@override
	Widget build(BuildContext context) {
		SizeConfig().init(context);
		return Scaffold(
			body: SafeArea(
				child: Stack(
					children: <Widget>[
					// Background of the screen
						Container(
							color: Color(0xff232526),
						),
						SingleChildScrollView(
							child: Center(
								child: Column(
									mainAxisSize: MainAxisSize.min,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: <Widget>[
										// OpenCon Logo
										Container(
											padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*70),
											width: SizeConfig.blockSizeHorizontal*60,
											decoration: BoxDecoration(
												image: DecorationImage(
													image: AssetImage('assets/opencon_logo.png')
												)
											),
										),
										Container(
											width: SizeConfig.screenWidth/1.3,
										  child: FlatButton(
										  	color: Color(0xffF3F3F3),
										  	textColor: Colors.black,
										  	shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*1.5)),
										  	child: Row(
													mainAxisAlignment: MainAxisAlignment.spaceAround,
									      	children: <Widget>[
														Container(
															child: Image.asset('assets/google_logo.png'),
															width: SizeConfig.blockSizeHorizontal*13,
														),
														Text('Continue with Google', style: TextStyle(
															fontFamily: 'Blinker',
															color: Colors.black,
															fontSize: SizeConfig.blockSizeVertical*3
														),)
									      	],
												),
										  	onPressed: () {
										  		print('something');
										  		try{
										  			 Provider.of<Auth>(context, listen: false).signInWithGoogle().then((response) {
															Navigator.of(context).popAndPushNamed(RegisterScreen.routeName);
													  });
												  } catch(e){
										  			throw e;
												  }
											  },
										  ),
										),
										Container(
											padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
											width: SizeConfig.screenWidth/1.3,
										  child: FlatButton(
										  	color: Color(0xffF3F3F3),
										  	textColor: Colors.black,
										  	shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical*1.5)),
										  	child: Row(
													mainAxisAlignment: MainAxisAlignment.spaceAround,
									      	children: <Widget>[
														Container(
															padding: EdgeInsets.fromLTRB(0, SizeConfig.blockSizeVertical*1.7, 0, SizeConfig.blockSizeVertical*1.7),
															child: Image.asset('assets/github.png', height: SizeConfig.blockSizeVertical*4,),
															width: SizeConfig.blockSizeHorizontal*13,
														),
														Text('Continue with GitHub', style: TextStyle(
															fontFamily: 'Blinker',
															color: Colors.black,
															fontSize: SizeConfig.blockSizeVertical*3
														),)
									      	],
												),
												onPressed: (){
													Provider.of<Auth>(context, listen: false).onClickGitHubLoginButton();
												},
											)
										)
									]
								),
							),
						)
					],
				),
			),
		);
	}
}
