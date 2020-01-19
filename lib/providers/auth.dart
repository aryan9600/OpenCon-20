import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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