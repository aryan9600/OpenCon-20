import 'package:flutter/material.dart';
import 'package:open_con/providers/auth.dart';
import 'package:open_con/screens/auth_screen.dart';
import 'package:open_con/screens/register_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

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
		    		primarySwatch: Colors.blue,
		    	),
		    	home: RegisterScreen()
		    ),
		  ),
		);
	}
}



