import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/values/colors.dart';
import 'package:ulearning_app/page/chat/pages/friend_list_page.dart';
import 'package:ulearning_app/page/home/home_page.dart';
import 'package:ulearning_app/page/profile/profile.dart';
import 'package:ulearning_app/page/search/search_page.dart';

Widget buildPage(int index) {
  List<Widget> _widget = [
    HomePage(),
    SearchPage(),
    Center(child: Text("Home")),
    FriendListPage(),
    ProfilePage(),
  ];

  return _widget[index];
}

var bottomTabs = [
  BottomNavigationBarItem(
      label: "home",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Image.asset("assets/icons/home.png"),
      ),
      activeIcon: SizedBox(
          width: 15.w,
          height: 15.h,
          child: Image.asset(
            "assets/icons/home.png",
            color: AppColors.primaryElement,
          ))),
  BottomNavigationBarItem(
      label: "search",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Image.asset("assets/icons/search2.png"),
      ),
      activeIcon: SizedBox(
          width: 15.w,
          height: 15.h,
          child: Image.asset(
            "assets/icons/search2.png",
            color: AppColors.primaryElement,
          ))),
  BottomNavigationBarItem(
      label: "course",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Image.asset("assets/icons/play-circle1.png"),
      ),
      activeIcon: SizedBox(
          width: 15.w,
          height: 15.h,
          child: Image.asset(
            "assets/icons/play-circle1.png",
            color: AppColors.primaryElement,
          ))),
  BottomNavigationBarItem(
      label: "chat",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Image.asset("assets/icons/message-circle.png"),
      ),
      activeIcon: SizedBox(
          width: 15.w,
          height: 15.h,
          child: Image.asset(
            "assets/icons/message-circle.png",
            color: AppColors.primaryElement,
          ))),
  BottomNavigationBarItem(
      label: "profile",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Image.asset("assets/icons/person2.png"),
      ),
      activeIcon: SizedBox(
          width: 15.w,
          height: 15.h,
          child: Image.asset(
            "assets/icons/person2.png",
            color: AppColors.primaryElement,
          ))),
];
