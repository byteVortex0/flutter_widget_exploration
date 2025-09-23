import 'package:flutter/material.dart';
import 'package:flutter_widget_exploration/widgets/advanced_animation.dart';
import 'package:flutter_widget_exploration/widgets/dismissible_lists.dart';
import 'package:flutter_widget_exploration/widgets/physics_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    DismissibleLists(),
    PhysicsWidget(),
    AdvancedAnimation(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: screens[currentIndex],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: NavigationBar(
          onDestinationSelected: (index) =>
              setState(() => currentIndex = index),
          selectedIndex: currentIndex,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.list), label: 'Task 1'),
            NavigationDestination(
              icon: Icon(Icons.tapas_sharp),
              label: 'Task 2',
            ),
            NavigationDestination(icon: Icon(Icons.animation), label: 'Task 3'),
          ],
        ),
      ),
    );
  }
}
