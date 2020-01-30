	// Template for error dialog
	import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

	String formatTimestampDate(DateTime timestamp) {
		  var formatter = new DateFormat('yyyy-MM-dd');
			String formattedDate = formatter.format(timestamp);
			return formattedDate;
}

// String formatTimestampTime(int timestamp) {
//       var format = new DateFormat('d MMM, hh:mm a');
//       var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
//       return format.format(date);
//     }
