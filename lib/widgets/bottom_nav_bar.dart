import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxia/constants/app_colors.dart';
import 'package:taxia/providers/home/bootom_nav_bar_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBarProvider>(
      builder: (BuildContext context,
          BottomNavBarProvider bottomNavigationProvider, Widget? child) {
        return BottomNavigationBar(
          currentIndex: bottomNavigationProvider.currentIndex,
          onTap: (index) {
            bottomNavigationProvider.setIndex(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: AppColors.iconColor,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.badge_outlined,
                color: AppColors.iconColor,
              ),
              label: "Business",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications_none_outlined,
                color: AppColors.iconColor,
              ),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_outlined,
                color: AppColors.iconColor,
              ),
              label: "My Info",
            ),
          ],
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: TextStyle(
            color: AppColors.textColor,
          ),
        );
      },
    );
  }
}
