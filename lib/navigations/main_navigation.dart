import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_to_do_apps/add_task.dart';
import 'package:project_to_do_apps/home_page.dart';
import 'package:project_to_do_apps/list_task.dart';
import 'package:project_to_do_apps/profile_page.dart';
import 'package:project_to_do_apps/tasks.dart';
import '../templates/dummy_pages.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int myCurrentIndex = 0;

  List pages = [HomePage(), Tasks(), AddTask(), ListTask(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.2),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          );
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(myCurrentIndex),
          child: pages[myCurrentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: myCurrentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFFE6521F),
          unselectedItemColor: Color(0xFFFB9E3A),
          selectedItemColor: const Color(0xFFFFFFFF),

          onTap: (index) {
            setState(() {
              myCurrentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/icon_home.svg',
                width: 25,
                color: myCurrentIndex == 0 ? Colors.white : Color(0xFFFB9E3A),
              ),
              label: '',
            ),

            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/icon_tasks.svg',
                width: 25,
                color: myCurrentIndex == 1 ? Colors.white : Color(0xFFFB9E3A),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/icon_plus.svg',
                width: 25,
                color: myCurrentIndex == 2 ? Colors.white : Color(0xFFFB9E3A),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/icon_lists.svg',
                width: 25,
                color: myCurrentIndex == 3 ? Colors.white : Color(0xFFFB9E3A),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/icon_profile.svg',
                width: 25,
                color: myCurrentIndex == 4 ? Colors.white : Color(0xFFFB9E3A),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
