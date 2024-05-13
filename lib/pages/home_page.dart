import 'package:agriplant/components/my_drawer.dart';
import 'package:agriplant/pages/cart_page.dart';
import 'package:agriplant/pages/explore_page.dart';
import 'package:agriplant/pages/forum_page.dart';
import 'package:agriplant/pages/profile_page.dart';
//import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pages = [ExplorePage(), ForumPage(), const CartPage(), ProfilePage()];
  int currentPageIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton.filledTonal(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              " Agrapp A farmer perfect companion 👋🏾",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text("Welcome to Agrapp",
                style: Theme.of(context).textTheme.bodySmall)
          ],
        ),
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPageIndex,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.home),
            label: "Home",
            activeIcon: Icon(IconlyBold.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: "Forum",
            activeIcon: Icon(Icons.insert_comment_outlined),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist),
            label: "AI Doctor",
            activeIcon: Icon(Icons.local_florist),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
