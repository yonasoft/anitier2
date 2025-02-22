import 'package:anitier2/src/features/account/presentation/pages/account_page.dart';
import 'package:anitier2/src/features/create/presentation/pages/create.dart';
import 'package:anitier2/src/features/home/presentation/pages/home.dart';
import 'package:anitier2/src/features/main/models/navigation_item.dart';
import 'package:anitier2/src/features/main/presentation/widgets/bot_navbar.dart';
import 'package:anitier2/src/features/main/presentation/widgets/nav_rail.dart';
import 'package:anitier2/src/features/saved/presentation/pages/saved_page.dart';
import 'package:anitier2/src/features/templates/presentation/pages/templates_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedNavIndex = 0;
  final _navigationItems = [
    NavigationItem(
        icon: Icons.home,
        label: 'Home',
        route: 'home',
        tooltip:
            'View, search, and sort from tier lists created by the community.'),
    NavigationItem(
        icon: Icons.article,
        label: 'Templates',
        route: 'templates',
        tooltip:
            'View and rank from templates AKA pre-made and  unranked tier lists'),
    NavigationItem(
        icon: Icons.add,
        label: 'Create',
        route: 'create',
        tooltip: 'Create your own tier lists or templates'),
    NavigationItem(
        icon: Icons.favorite,
        label: 'Saved',
        route: 'saved',
        tooltip: 'Your saved tier lists.'),
    NavigationItem(
        icon: Icons.account_box,
        label: 'Account',
        route: 'account',
        tooltip: 'Manage your accounts')
  ];

  @override
  void initState() {}
  void _onTap(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(this.context).size.width;

    final page = IndexedStack(
      index: _selectedNavIndex,
      children: [
        HomePage(),
        TemplatesPage(),
        CreatePage(),
        SavedPage(),
        AccountPage(),
      ],
    );

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: screenWidth < 600
            ? BotNavbar(
                navItems: _navigationItems,
                selectedIndex: _selectedNavIndex,
                onTap: _onTap,
              )
            : null,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (screenWidth >= 600)
              NavRail(
                  navItems: _navigationItems,
                  selectedIndex: _selectedNavIndex,
                  onTap: _onTap),
            Expanded(child: page),
          ],
        ),
      ),
    );
  }
}
