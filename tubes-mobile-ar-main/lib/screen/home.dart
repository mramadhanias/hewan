import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tubes_market_hewan/screen/fav.dart';
import 'package:tubes_market_hewan/screen/homepage.dart';
import 'package:tubes_market_hewan/screen/product.dart';
import 'package:tubes_market_hewan/screen/user.dart';
import 'package:tubes_market_hewan/style/color.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final PageController controller = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = 1;
      controller.animateToPage(index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(0, 212, 70, 70),
          Color.fromRGBO(148, 140, 33, 0)
        ], begin: Alignment.topLeft, end: Alignment.topRight)),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(0, 212, 70, 70),
              Color.fromRGBO(148, 140, 33, 0)
            ], begin: Alignment.topLeft, end: Alignment.topRight)),
            child: PageView(
              controller: controller,
              onPageChanged: (value) => setState(() {
                _selectedIndex = value;
              }),
              children: [
                Homepage(),
                Product(),
                Fav(),
                User(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.searchengin),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidHeart),
            label: 'Fav',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userLarge),
            label: 'User',
          ),
        ],
        // enableFeedback: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        unselectedItemColor: navy.withOpacity(0.3),
        selectedItemColor: navy,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        //backgroundColor: Color.fromARGB(244, 24, 209, 101),
        iconSize: 20,
        onTap: _onItemTapped,
      ),
    );
  }
}
