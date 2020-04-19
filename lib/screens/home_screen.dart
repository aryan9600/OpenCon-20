import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:open_con/screens/about_event_screen.dart';
import 'package:open_con/screens/profile_screen.dart';
import 'package:open_con/screens/timeline_screen.dart';
import 'package:open_con/utils/size_config.dart';
import 'package:open_con/widgets/nav_bar.dart';

class ScreenWithIndex{
  final Widget screen;
  final int index;

  ScreenWithIndex({this.screen, this.index});
}


class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin<HomeScreen>{

  List<Key> _destinationKeys;
  List<AnimationController> _faders;
  int _currentIndex = 0;


  final List<ScreenWithIndex> _children = [
    ScreenWithIndex(
      screen: AboutEventScreen(),
      index: 0
    ),
    ScreenWithIndex(
      screen: TimelineScreen(),
      index: 1
    ),
    ScreenWithIndex(
      screen: ProfileScreen(),
      index: 2
    ),
  ];

  @override
  void initState() {
    super.initState();
    _faders = _children.map<AnimationController>((ScreenWithIndex screen) {
      return AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys = List<Key>.generate(_children.length, (int index) => GlobalKey()).toList();
  }
  @override
  void dispose() {
  for (AnimationController controller in _faders)
    controller.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: _children.map((ScreenWithIndex screen) {
            final Widget view = FadeTransition(
              opacity: _faders[screen.index].drive(CurveTween(curve: Curves.fastOutSlowIn)),
              child: KeyedSubtree(
                key: _destinationKeys[screen.index],
                child: _children[screen.index].screen
              ),
            );
            if (screen.index == _currentIndex) {
              _faders[screen.index].forward();
              return view;
            } else {
              _faders[screen.index].reverse();
              if (_faders[screen.index].isAnimating) {
                return IgnorePointer(child: view);
              }
              return Offstage(child: view);
            }
          }).toList(),
        ),
      ),
      bottomNavigationBar: HighlightNavigationBar(
        onchanged: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        height: SizeConfig.blockSizeVertical*9,
        // backgroundColor: Colors.white,
        // selectedIconColor: Color(0xff00B7D0),
        // highLightColor: Color(0xff00B7D0),
        // duration: Duration(milliseconds: 300),
        icons: [
          IconButton(icon: Icon(Icons.info_outline), onPressed: (){}),
          IconButton(icon: Icon(Icons.timeline), onPressed: (){}),
          IconButton(icon: Icon(Icons.person_outline), onPressed: (){}),
        ],
      ),
    );
  }
}