// The Login/SignUp screen.

import 'package:flutter/material.dart';
import 'package:open_con/providers/auth.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:provider/provider.dart';

// Enumeration to keep track of the status of the screen.
enum AuthMode{
	Login,
	SignUp
}

// Initializing the screen to show the Login page UI
AuthMode _authMode = AuthMode.Login;

class AuthScreen extends StatefulWidget {
	@override
	_AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {


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
															 print('yay signed in');
													  });
												  } catch(e){
										  			throw e;
												  }
											  },
										  ),
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
