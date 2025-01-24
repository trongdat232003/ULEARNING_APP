import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/routes/names.dart';
import 'package:ulearning_app/common/values/colors.dart';
import 'package:ulearning_app/common/widgets/base_text_widget.dart';

AppBar buildAppBar() {
  return AppBar(
    centerTitle: true,
    title: reusableText("Course Detail"),
  );
}

Widget thumbNail(String imageUrl) {
  return Container(
    width: 325.w,
    height: 200.h,
    decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fitWidth, image: NetworkImage(imageUrl))),
  );
}

Widget menuView(int follow, int score) {
  return SizedBox(
    width: 325.w,
    child: Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            decoration: BoxDecoration(
                color: AppColors.primaryElement,
                borderRadius: BorderRadius.circular(7.w),
                border: Border.all(color: AppColors.primaryElement)),
            child: reusableText("Author Page",
                color: AppColors.primaryElementText,
                fontWeight: FontWeight.normal,
                fontSize: 10),
          ),
        ),
        _iconAndNum("assets/icons/people.png", follow),
        _iconAndNum("assets/icons/star.png", score),
      ],
    ),
  );
}

Widget _iconAndNum(String iconPath, int num) {
  return Container(
    margin: EdgeInsets.only(left: 30.w),
    child: Row(
      children: [
        Image(
          image: AssetImage(iconPath),
          width: 20.w,
          height: 20.h,
        ),
        reusableText(num.toString(),
            color: AppColors.primaryThirdElementText,
            fontSize: 11,
            fontWeight: FontWeight.normal)
      ],
    ),
  );
}

Widget descriptionText(String description) {
  return reusableText(description,
      color: AppColors.primaryThirdElementText,
      fontWeight: FontWeight.normal,
      fontSize: 11);
}

Widget goBuyButton(String name, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.only(top: 13.h),
      width: 330.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.primaryElement,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: AppColors.primaryElement),
      ),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryElementText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}

Widget courseSummaryTitle() {
  return reusableText(
    "The Course Includes",
    fontSize: 14,
  );
}

Widget courseSummaryView(BuildContext context, int videoLength, int lessonNum,
    int downloadableResources) {
  var dynamicInfo = <String, String>{
    "$videoLength Hours Video": "video_detail.png",
    "Total $lessonNum lessons": "file_detail.png",
    "$downloadableResources Downloadable Resources": "download_detail.png",
  };

  return Column(
    children: [
      ...List.generate(
        dynamicInfo.length,
        (index) => GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.SETTINGS),
          child: Container(
            margin: EdgeInsets.only(top: 15.h),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/icons/${dynamicInfo.values.elementAt(index)}",
                    width: 30.w,
                    height: 30.h,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      color: AppColors.primaryElement),
                ),
                SizedBox(width: 15.w),
                Text(
                  dynamicInfo.keys.elementAt(index),
                  style: TextStyle(
                      color: AppColors.primarySecondaryElementText,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp),
                ),
              ],
            ),
          ),
        ),
      )
    ],
  );
}

Widget courseLessonList(String lessonName, String thumbnail) {
  return Container(
    width: 325.w,
    height: 80.h,
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
    decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 1))
        ]),
    child: InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.h),
                    image: DecorationImage(
                        fit: BoxFit.fill, image: NetworkImage(thumbnail))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _listContainer(lessonName),
                ],
              )
            ],
          ),
          Container(
            child: Image(
                height: 24.h,
                width: 24.h,
                image: AssetImage("assets/icons/arrow_right.png")),
          )
        ],
      ),
    ),
  );
}

Widget _listContainer(String text,
    {double fontSize = 13,
    Color color = AppColors.primaryText,
    fontWeight = FontWeight.bold}) {
  return Container(
    width: 200.w,
    margin: EdgeInsets.only(left: 6.w),
    child: Text(
      text,
      overflow: TextOverflow.clip,
      maxLines: 1,
      style: TextStyle(
          color: color, fontSize: fontSize.sp, fontWeight: FontWeight.bold),
    ),
  );
}
