import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;
  final String? tooltip;

  NavigationItem(
      {required this.icon,
      required this.label,
      required this.route,
      this.tooltip});
}

final navigationItems = [
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
