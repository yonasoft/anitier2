import 'package:anitier2/src/features/skeleton/models/navigation_item.dart';
import 'package:flutter/material.dart';

class BotNavbar extends StatefulWidget {
  final List<NavigationItem> navItems;
  final int selectedIndex;
  final Function(int) onTap;

  const BotNavbar({
    super.key,
    required this.navItems,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<BotNavbar> createState() => _BotNavbarState();
}

class _BotNavbarState extends State<BotNavbar> {
  @override
  Widget build(BuildContext context) {
    final botNavItems = widget.navItems
        .map((item) => item.route != 'create'
            ? BottomNavigationBarItem(icon: Icon(item.icon), label: item.label)
            : null)
        .whereType<BottomNavigationBarItem>()
        .toList();

    return BottomNavigationBar(
        currentIndex: widget.selectedIndex,
        onTap: (index) => {widget.onTap(index)},
        selectedItemColor: Color.fromRGBO(88, 133, 175, 1),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        items: [...botNavItems]);
  }
}
