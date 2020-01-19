	// Template for error dialog
	import 'package:flutter/material.dart';

void showErrorDialog(String error, BuildContext context){
		showDialog(
			context: context,
			builder: (ctx) => AlertDialog(
				title: Text('Snap! Something went wrong. :('),
				content: Text('$error'),
				actions: <Widget>[
					FlatButton(
						child: Text('Got it!'),
						onPressed:() {Navigator.of(ctx).pop();},
					)
				],
			)
		);
	}