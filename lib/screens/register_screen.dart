import 'package:flutter/material.dart';
import 'package:open_con/backend/auth.dart';
import 'package:open_con/screens/about_event_screen.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:open_con/backend/user.dart';

import '../utils/size_config.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {

  static const routeName = '/registerScreen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // keys for the form and the scaffold
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  final _teamNameController = TextEditingController();
  final _userNameController = TextEditingController();

   
  void _submit(token, name, team, email) async{
    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();

    print(token);
    try{
      final user = User();
      user.createUser(token, name, team, email);
    }catch(e){
      throw e;
    }
  }


  @override
  Widget build(BuildContext context) {
    
    final _user = Provider.of<Auth>(context, listen: false);
    
    SizeConfig().init(context);

  	return Scaffold(
      key: _scaffoldKey,
		  body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: SizeConfig.blockSizeVertical*5),
                Text('Please enter the required details.', style: TextStyle(
                  fontFamily: 'Blinker',
                  fontSize: SizeConfig.blockSizeVertical*3,
                ),),
                Container(
                  padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*40),
                  width: SizeConfig.blockSizeHorizontal*60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/frame.png')
                    )
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth/1.2,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        // Email Textfield
                        TextFormField(
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontFamily: 'Blinker',
                            fontSize: SizeConfig.blockSizeVertical*3
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Color(0xff00B7D0),
                              fontSize: SizeConfig.blockSizeHorizontal*5,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Blinker'
                            ),
                            contentPadding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal, 0, 0, SizeConfig.blockSizeVertical*0.8),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[500])
                            )
                          ),
                          initialValue: "jaiswalsanskar078@gmail.com",
                          enabled: false,
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical*4,),

                        // User Name Textfield
                        TextFormField(
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'Blinker',
                            fontSize: SizeConfig.blockSizeVertical*3
                          ),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              color: Color(0xff00B7D0),
                              fontSize: SizeConfig.blockSizeHorizontal*5,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Blinker'
                            ),
                            hintText:  "Your full name",
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: SizeConfig.blockSizeHorizontal*5,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Blinker'
                            ),
                            contentPadding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal, 0, 0, SizeConfig.blockSizeVertical*0.8),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black45),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300])
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                            ),
                          ),
                          enabled: true,
                          controller: _userNameController
                          
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical*4,),

                        // Team Name Text Field
                        TextFormField(
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontFamily: 'Blinker',
                            fontSize: SizeConfig.blockSizeVertical*3
                          ),
                          decoration: InputDecoration(
                            labelText: 'Team Name',
                            hintText:  "Your team's name",
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: SizeConfig.blockSizeHorizontal*5,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Blinker'
                            ),
                            labelStyle: TextStyle(
                              color: Color(0xff00B7D0),
                              fontSize: SizeConfig.blockSizeHorizontal*5,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Blinker'
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                            ),
                            contentPadding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal, 0, 0, SizeConfig.blockSizeVertical*0.8),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black45),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300])
                            )
                          ),
                          enabled: true,
                          controller: _teamNameController,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical*5,),
                        RaisedButton(
                          onPressed: (){
                            print(_teamNameController.text);
                            print('lol');
                            _submit(_user.uIdToken, _userNameController.text, _teamNameController.text, _user.userEmail);
                            Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
                          },
                          elevation: 100,
                          child: Text('Done', style: TextStyle(
                            fontFamily: 'Blinker',
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeVertical*3
                          ),),
                          color: Color(0xff00B7D0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical),
                          ),
                          padding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*23, SizeConfig.blockSizeVertical*1.5, SizeConfig.blockSizeHorizontal*23, SizeConfig.blockSizeVertical*1.8),
                        ),

                        SizedBox(height: SizeConfig.blockSizeVertical*3,)
                      ],
                    ),
                  ),
                )
              ],
            )
          )
        )
		  ),
	  );
  }
}

