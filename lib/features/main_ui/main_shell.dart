import 'package:flutter/material.dart';
import 'package:lumiere/core/widgets/app_bottom_nav.dart';
import 'package:lumiere/features/main_ui/home_screen.dart';
import 'package:lumiere/features/main_ui/profile_screen.dart';
import 'package:lumiere/features/main_ui/search_screen.dart';


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: [
          HomeScreen(onSearchTap: () => setState(() => index = 1)),
           SearchScreen(),
           ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
      ),
    );
  }
}