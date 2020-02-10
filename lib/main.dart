import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/screens/about_event_screen.dart';
import 'package:open_con/screens/auth_screen.dart';
import 'package:open_con/screens/profile_screen.dart';
import 'package:open_con/screens/register_screen.dart';
import 'package:open_con/screens/timeline_screen.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';


void main() async {
  await DotEnv().load('.ENV');
	 Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.microphone,]);
	runApp(MyApp());
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
		    	theme: ThemeData(
						brightness: Brightness.dark,
						canvasColor: Color(0xff232526),
						accentColor: Color(0xff00B7D0),
						fontFamily: "Blinker",
						primaryTextTheme: TextTheme(
							headline: TextStyle(
								color: Color(0xff00B7D0),
								fontWeight: FontWeight.bold,
							),
							title: TextStyle(
								color: Colors.white,
								fontWeight: FontWeight.w400,
							),
							subtitle: TextStyle(
								color: Color.fromRGBO(255, 255, 255, 0.5),
							),
						),
						buttonTheme: ButtonThemeData(
							buttonColor: Color(0xff00B7D0),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical),
							),
							padding: EdgeInsets.fromLTRB( 23,  1.5,  23,  1.8),
							textTheme: ButtonTextTheme.normal
						),
		    	),
		    	home: ProfileScreen(),
					routes: {
						RegisterScreen.routeName: (ctx) => RegisterScreen(),
					},
		    ),
		  ),
		);
	}
}


