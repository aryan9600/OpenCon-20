import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:open_con/models/github_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';



	String githubClientID = DotEnv().env['CLIENT_ID'];
	String githubClientSecret = DotEnv().env['CLIENT_SECRET'];
// All authentication methods reside inside this class.
class Auth with ChangeNotifier {
	final FirebaseAuth _auth = FirebaseAuth.instance;
	final GoogleSignIn googleSignIn = GoogleSignIn();
	String _uIdToken;
	String _userEmail;
  String _userName;


	bool get isAuth {
		return uIdToken != null;
	}

	String get uIdToken {
		return _uIdToken;
	}

	String get userEmail {
		return _userEmail;
	}

  String get userName {
    return _userName;
  }


	void onClickGitHubLoginButton() async {
		String url = "https://github.com/login/oauth/authorize" +
				"?client_id=" +"$githubClientID"+
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


	Future<FirebaseUser> loginWithGitHub(String code) async {
		//ACCESS TOKEN REQUEST
		print(code);
		final response = await http.post(
			"https://github.com/login/oauth/access_token",
			headers: {
				"Content-Type": "application/json",
				"Accept": "application/json"
			},
			body: jsonEncode(GitHubLoginRequest(
				clientId: githubClientID,
				clientSecret: githubClientSecret,
				code: code,
			)),
		);
		print(response.body);

		GitHubLoginResponse loginResponse =
				GitHubLoginResponse.fromJson(json.decode(response.body));
		
		print(loginResponse);
		//FIREBASE STUFF
		final AuthCredential credential = GithubAuthProvider.getCredential(
			token: loginResponse.accessToken,
		);
		print('we got here');
		final AuthResult user = await FirebaseAuth.instance.signInWithCredential(credential);
		return user.user;
	}
	
	// Signing in a user with his/her Google account.
	Future<FirebaseUser> signInWithGoogle() async {
		try{
			print('lol');
			final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
			final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

			final AuthCredential credential = GoogleAuthProvider.getCredential(
				accessToken: googleSignInAuthentication.accessToken,
				idToken: googleSignInAuthentication.idToken,
			);

			final AuthResult user = await _auth.signInWithCredential(credential);

			assert(!user.user.isAnonymous);
			assert(await user.user.getIdToken() != null);

			final FirebaseUser currentUser = await _auth.currentUser();
			assert(user.user.uid == currentUser.uid);

			_uIdToken = user.user.uid;
			_userEmail = user.user.email;
      _userName = user.user.displayName;
			notifyListeners();
			final prefs = await SharedPreferences.getInstance();
			prefs.setString('uId', _uIdToken);
			return user.user;
		}
		catch(error){
			throw error;
		}
	}

	// method to automatically sign in users even if the app was removed from memory.
	Future<bool> autoLogin() async {
		final prefs = await SharedPreferences.getInstance();
		if (!prefs.containsKey('uId')) {
			return false;
		}
		final token = prefs.getString('uId');
		print('automatically logged in');
		_uIdToken = token;
		notifyListeners();
		return true;
	}

  // method to sign out the user.
  Future<void> signOutGoogle() async{
		try{
			await googleSignIn.signOut();
			print("User Signed Out");
		} catch(error){
			throw error;
		}
  }
}