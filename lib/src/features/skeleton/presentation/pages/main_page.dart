import 'package:anitier2/src/features/skeleton/models/navigation_item.dart';
import 'package:anitier2/src/features/skeleton/presentation/widgets/bot_navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;
  final _navigationItems = [
    NavigationItem(icon: Icons.home, label: 'Home', route: 'home'),
    NavigationItem(icon: Icons.article, label: 'Templates', route: 'templates'),
    NavigationItem(icon: Icons.add, label: 'Create', route: 'create'),
    NavigationItem(icon: Icons.favorite, label: 'Saved', route: 'saved'),
    NavigationItem(icon: Icons.account_box, label: 'Account', route: 'account')
  ];

  void _onTap(int index) => {
        setState(() {
          _selectedNavIndex = index;
        })
      };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(this.context).size.width;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: screenWidth < 600
            ? BotNavbar(
                navItems: _navigationItems,
                selectedIndex: _selectedNavIndex,
                onTap: _onTap,
              )
            : null,
        body: Row(),
      ),
    );
  }
}
