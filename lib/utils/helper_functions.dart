	// Template for error dialog
	import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HelperFunctions{
	
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

	String timestampToDate(Timestamp time){
		final df = DateFormat('dd MMM');
		final formattedDate = df.format(time.toDate());
		return formattedDate.toString();
	}

	String timestampToTime(Timestamp time){
		final df = DateFormat('hh:mm a');
		final formattedDate = df.format(time.toDate());
		return formattedDate.toString();
	}
}