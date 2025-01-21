import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/common/routes/names.dart';
import 'package:ulearning_app/common/service/userService.dart';
import 'package:ulearning_app/common/values/colors.dart';
import 'package:ulearning_app/page/home/bloc/home_page_blocs.dart';
import 'package:ulearning_app/page/home/bloc/home_page_events.dart';
import 'package:ulearning_app/page/home/bloc/home_page_states.dart';
import 'package:ulearning_app/page/home/widgets/home_page_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'dbestech';
  String avatarUrl = '';
  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    context.read<HomePageBlocs>().add(LoadCourses());
  }

  Future<void> _fetchUserProfile() async {
    String? token = await UserService.getToken();
    if (token != null) {
      var response = await UserService.getuserProfile(token);
      if (response['success']) {
        setState(() {
          userName = response['data']['name'] ?? 'Unknown';
          avatarUrl =
              response['data']['avatar'] ?? ''; // Cập nhật tên người dùng
        });
      } else {
        print(response['message']);
      }
    } else {
      print('No token found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(avatarUrl),
        body: BlocBuilder<HomePageBlocs, HomePageStates>(
            builder: (context, state) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 0.w, horizontal: 25.w),
            child: CustomScrollView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              slivers: [
                SliverToBoxAdapter(
                  child: homePageText("Hello",
                      color: AppColors.primaryThirdElementText, top: 20),
                ),
                SliverToBoxAdapter(
                  child: homePageText(userName, top: 5),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 20.h),
                ),
                SliverToBoxAdapter(
                  child: searchView(),
                ),
                SliverToBoxAdapter(
                  child: slidersView(context, state),
                ),
                SliverToBoxAdapter(
                  child: menuView(),
                ),
                SliverPadding(
                    padding:
                        EdgeInsets.symmetric(vertical: 18.h, horizontal: 0.w),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        childCount: state.courses.length,
                        (BuildContext context, int index) {
                          final course = state.courses[index];
                          return GestureDetector(
                            onTap: () async {
                              final course = state.courses.elementAt(index);

                              // Assuming you have the token available (e.g., from a shared preferences or user session)
                              final token = await UserService
                                  .getToken(); // Await the token retrieval

                              Navigator.of(context).pushNamed(
                                AppRoutes.COURSE_DETAIL,
                                arguments: {
                                  "id": course["_id"], // Pass the course id
                                  "token": token, // Pass the token
                                },
                              );
                            },
                            child: courseGrid(
                              course['thumbnail'], // URL hình ảnh
                              course['name'], // Tên khóa học
                              course['description'], // Mô tả khóa học
                            ),
                          );
                        },
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 1.6,
                      ),
                    ))
              ],
            ),
          );
        }));
  }
}
