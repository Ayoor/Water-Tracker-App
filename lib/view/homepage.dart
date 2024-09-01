import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'History.dart';
import '../Settings.dart';
import 'Dashboard.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: const Dashboard(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: const History(),
          item: ItemConfig(
            icon: const Icon(Icons.insert_chart),
            title: "History",
          ),
        ),
        PersistentTabConfig(
          screen: const Settings(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: "Settings",
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) =>
          Style4BottomNavBar(
            navBarConfig: navBarConfig,
          ),
    );
  }
}
