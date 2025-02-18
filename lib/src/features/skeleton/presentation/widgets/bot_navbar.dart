import 'package:flutter/material.dart';

class BotNavbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BotNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<BotNavbar> createState() => _BotNavbarState();
}

class _BotNavbarState extends State<BotNavbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: widget.selectedIndex,
        onTap: (index) => {widget.onTap(index)},
        selectedItemColor: Color.fromRGBO(88, 133, 175, 1),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Templates'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.account_box), label: 'Account'),
        ]);
  }
}
