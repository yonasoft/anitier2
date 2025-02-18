import 'package:anitier2/src/features/skeleton/presentation/widgets/bot_navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;
  final _navItems = ['activity', 'templates', 'saved', 'user'];
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
                selectedIndex: _selectedNavIndex,
                onTap: _onTap,
              )
            : null,
        body: Row(),
      ),
    );
  }
}
