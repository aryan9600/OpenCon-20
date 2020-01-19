import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // keys for the form and the scaffold
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _teamController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
  	return Scaffold(
      key: _scaffoldKey,
		  body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
						  color: Color(0xff232526),
						),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: SizeConfig.blockSizeVertical*3),
                    Container(
                      height: SizeConfig.blockSizeVertical*12,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/opencon_logo.png')
                        )
                      ),
                    ),
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
                                color: Colors.grey[400],
                                fontFamily: 'Blinker',
                                fontSize: SizeConfig.blockSizeVertical*2.5
                              ),
                              decoration: InputDecoration(
                                labelText: 'Your Email',
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
                                  borderSide: BorderSide(color: Colors.grey[300])
                                )
                              ),
                              initialValue: 'jaiswal.sanskar078@gmail.com',
                              enabled: true,
                            ),

                            SizedBox(height: SizeConfig.blockSizeVertical*4,),

                            // User Name Textfield
                            RegisterField(content:'Enter your name here', upperText: 'Your name', estatus: true, editingController: _nameController,),

                            SizedBox(height: SizeConfig.blockSizeVertical*4,),

                            // Team Name Text Field
                            RegisterField(estatus: true, content: 'Enter your team name here', upperText: 'Team Name', editingController: _teamController,),

                            SizedBox(height: SizeConfig.blockSizeVertical*5,),

                            RaisedButton(
                              onPressed: (){},
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
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              )
            )
          ],
        ),
		  ),
	  );
  }
}

class RegisterField extends StatelessWidget {
  
  bool estatus;
  String upperText;
  String content;
  TextEditingController editingController;
  RegisterField({
    this.estatus,
    this.content,
    this.upperText,
    this.editingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: Colors.grey[400],
        fontFamily: 'Blinker',
        fontSize: SizeConfig.blockSizeVertical*2.5
      ),
      decoration: InputDecoration(
        hintText: content,
        labelText: upperText,
        labelStyle: TextStyle(
          color: Color(0xff00B7D0),
          fontSize: SizeConfig.blockSizeHorizontal*5,
          fontStyle: FontStyle.normal,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[300],
          fontSize: SizeConfig.blockSizeVertical*2.5,
          fontFamily: 'Blinker'
        ),
        contentPadding: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal, 0, 0, SizeConfig.blockSizeVertical*0.8),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300])
        )
      ),
      enabled: true,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      autocorrect: true,
      controller: editingController,
    );
  }
}
