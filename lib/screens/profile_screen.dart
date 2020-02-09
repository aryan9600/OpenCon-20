import 'package:flutter/material.dart';
import 'package:open_con/utils/size_config.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              color: ThemeData.dark().canvasColor,
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: SizeConfig.blockSizeVertical*15,),
                    Container(
                      height: SizeConfig.blockSizeVertical*25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/qr.png')
                        )
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}