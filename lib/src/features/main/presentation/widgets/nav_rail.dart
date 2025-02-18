import 'package:anitier2/src/features/main/models/navigation_item.dart';
import 'package:flutter/material.dart';

class NavRail extends StatefulWidget {
  final List<NavigationItem> navItems;
  final int selectedIndex;
  final Function(int) onTap;

  const NavRail({
    super.key,
    required this.navItems,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<NavRail> createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(this.context).size.width;

    final navRailDestinations = widget.navItems
        .map((item) => NavigationRailDestination(
              icon: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0), // Adjust spacing here
                child: Icon(item.icon),
              ),
              label: Text(item.label),
            ))
        .whereType<NavigationRailDestination>()
        .toList();

    return NavigationRail(
      destinations: [...navRailDestinations],
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: (index) => widget.onTap(index),
      extended: screenWidth >= 840,
    );
  }
}
