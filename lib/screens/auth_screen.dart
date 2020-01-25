// The Login/SignUp screen.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/screens/register_screen.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';


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
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      Provider.of<Auth>(context).loginWithGitHub(code)
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

	
	void onClickGitHubLoginButton() async {
		const String url = "https://github.com/login/oauth/authorize" +
				"?client_id=" + "968c0277a36abe9c5c9d" +
				"&scope=public_repo%20read:user%20user:email";

		if (await canLaunch(url)) {
			await launch(
				url,
				forceSafariVC: false,
				forceWebView: false,
			);
		} else {
			print("CANNOT LAUNCH THIS URL!");
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
													mainAxisAlignment: MainAxisAlignment.center,
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
													mainAxisAlignment: MainAxisAlignment.center,
									      	children: <Widget>[
														Container(
															child: Image.asset('assets/google_logo.png'),
															width: SizeConfig.blockSizeHorizontal*13,
														),
														Text('Continue with GitHub', style: TextStyle(
															fontFamily: 'Blinker',
															color: Colors.black,
															fontSize: SizeConfig.blockSizeVertical*3
														),)
									      	],
												),
												onPressed: onClickGitHubLoginButton,
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
