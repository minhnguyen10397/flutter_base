import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/colors.dart';
import '../../../routes/routes.gr.dart';

class MainTabBarPage extends StatelessWidget {
  const MainTabBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      lazyLoad: false,
      extendBody: true,
      backgroundColor: UIColors.background,
      routes: const [
        HomeRoute(),
        HomeRoute(),
        HomeRoute(),
        HomeRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black26,
            //     spreadRadius: 0,
            //     blurRadius: 5,
            //   ),
            // ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: UIColors.black,
                onTap: tabsRouter.setActiveIndex,
                currentIndex: tabsRouter.activeIndex < 2
                    ? tabsRouter.activeIndex
                    : tabsRouter.activeIndex + 1,
                selectedItemColor: UIColors.primary,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  BottomNavigationBarItem(
                    activeIcon: Image.asset(
                      'assets/images/apple_icon.png',
                      height: 18,
                      color: UIColors.primary,
                    ),
                    icon: Image.asset(
                      'assets/images/apple_icon.png',
                      height: 18,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Image.asset(
                      'assets/images/apple_icon.png',
                      height: 18,
                      color: UIColors.primary,
                    ),
                    icon: Image.asset(
                      'assets/images/apple_icon.png',
                      height: 18,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Image.asset(
                      'assets/images/apple_icon.png',
                      height: 18,
                      color: UIColors.primary,
                    ),
                    icon: Image.asset(
                      'assets/images/apple_icon.png',
                      height: 18,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Image.asset(
                      'assets/images/apple_icon.png',
                      height: 18,
                      color: UIColors.primary,
                    ),
                    icon: Image.asset(
                      'assets/images/apple_icon.png',
                      height: 18,
                    ),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
