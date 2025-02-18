import 'package:anitier2/src/features/create/presentation/pages/create.dart';
import 'package:anitier2/src/features/home/presentation/pages/home.dart';
import 'package:anitier2/src/features/main/models/navigation_item.dart';
import 'package:anitier2/src/features/main/presentation/widgets/bot_navbar.dart';
import 'package:anitier2/src/features/main/presentation/widgets/nav_rail.dart';
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

  void _onTap(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(this.context).size.width;

    final navigator = Navigator(
      pages: [
        if (_selectedNavIndex == 0)
          MaterialPage(key: ValueKey('home'), child: HomePage()),
        // if (_selectedNavIndex == 1)
        // MaterialPage(key: ValueKey('templates'), child: TemplatesPage()),
        if (_selectedNavIndex == 2)
          MaterialPage(key: ValueKey('create'), child: CreatePage()),
        // if (_selectedNavIndex == 3)
        //   MaterialPage(key: ValueKey('saved'), child: SavedPage()),
        // if (_selectedNavIndex == 4)
        //   MaterialPage(key: ValueKey('account'), child: AccountPage()),
      ],
      onDidRemovePage: (page) => {
        setState(() {
        })
      },
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
          children: [
            if (screenWidth >= 600)
              NavRail(
                  navItems: _navigationItems,
                  selectedIndex: _selectedNavIndex,
                  onTap: _onTap),
            Expanded(child: navigator)
          ],
        ),
      ),
    );
  }
}
