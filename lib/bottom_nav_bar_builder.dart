import 'package:e_commerce_ml/screens/chat_screen/chat_screen.dart';
import 'package:e_commerce_ml/screens/explore_screen/explore_screen.dart';
import 'package:e_commerce_ml/screens/my_listings_screen/my_listings_screen.dart';
import 'package:e_commerce_ml/screens/sell_screen/item_info_screen.dart';
import 'package:e_commerce_ml/screens/services/auth_service.dart';
import 'package:e_commerce_ml/screens/user_screen/user_screen.dart';
import 'package:flutter/material.dart';

AuthService authService = AuthService();

class BottomNavBarBuilder extends StatefulWidget {
  const BottomNavBarBuilder({super.key, this.indexToJump = 5});

  final int indexToJump;

  @override
  State<BottomNavBarBuilder> createState() => _BottomNavBarBuilderState();
}

class _BottomNavBarBuilderState extends State<BottomNavBarBuilder> {
  int currentIndex = 0;
  @override
  void initState() {
    widget.indexToJump != 5 ? currentIndex = widget.indexToJump : 0;
    super.initState();
  }

  final List<Widget> screens = <Widget>[
    const ExploreScreen(),
    const ChatScreen(),
    const ItemInfoScreen(),
    const MyListingsScreen(),
    const UserScreen()
  ];

  final List<Widget> items = [
    const NavigationDestination(
        icon: Icon(
          Icons.explore_rounded,
        ),
        label: "Keşfet"),
    const NavigationDestination(icon: Icon(Icons.chat), label: "Sohbet"),
    Container(),
    const NavigationDestination(
        icon: Icon(Icons.view_list_rounded), label: "İlanlarım"),
    const NavigationDestination(icon: Icon(Icons.person), label: "Kullanıcı"),
  ];
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return Scaffold(
        floatingActionButton: currentIndex == 2
            ? null
            : keyboardIsOpened
                ? null
                : FloatingActionButton(
                    heroTag: "12",
                    backgroundColor: const Color(0xFF124076),
                    focusColor: Colors.transparent,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    elevation: 0,
                    onPressed: () {
                      setState(() {
                        currentIndex = 2;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera_rounded,
                          color: Colors.white,
                        ),
                        Text(
                          "Sat",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    )),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        body: screens[currentIndex],
        bottomNavigationBar: NavigationBar(
          destinations: items,
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ));
  }
}
