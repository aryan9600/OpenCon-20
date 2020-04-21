import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/screens/about_event_screen.dart';
import 'package:open_con/screens/auth_screen.dart';
import 'package:open_con/screens/home_screen.dart';
import 'package:open_con/screens/profile_screen.dart';
import 'package:open_con/screens/register_screen.dart';
import 'package:open_con/screens/timeline_screen.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'screens/about_event_screen.dart';


void main() async{
	runApp(MyApp());
  await DotEnv().load('.ENV');
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				ChangeNotifierProvider.value(value: Auth())
			],
		  child: Consumer<Auth>(
			  builder: (ctx, auth, _) =>
		    MaterialApp(
		    	debugShowCheckedModeBanner: false,
		    	title: 'OpenCon\'20',
		    	home: AuthScreen(),
					routes: {
						RegisterScreen.routeName: (ctx) => RegisterScreen(),
						ProfileScreen.routeName: (ctx) => ProfileScreen(),
            AboutEventScreen.routeName: (ctx) => AboutEventScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
					},
		    )
		  ),
		);
	}
}


