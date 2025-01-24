import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/page/course/bloc/course_details_events.dart';
import 'package:ulearning_app/common/service/courseService.dart';
import 'package:ulearning_app/common/widgets/base_text_widget.dart';
import 'package:ulearning_app/page/course/bloc/couse_details_blocs.dart';
import 'package:ulearning_app/page/course/bloc/couse_details_states.dart';
import 'package:ulearning_app/page/course/widgets/course_details_widget.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CourseDetailBloc(),
      child: CourseDetailsView(),
    );
  }
}

class CourseDetailsView extends StatefulWidget {
  const CourseDetailsView({super.key});

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<CourseDetailsView> {
  late String courseId;
  late String token;
  void handlePayment(BuildContext context) async {
    final paymentMethodId = "pm_card_visa"; // Lấy từ user hoặc cài mặc định
    final result =
        await CourseService.checkoutCourse(courseId, token, paymentMethodId);
    print(result);
    if (result != null && result["message"] == "Payment successful") {
      final courseInfo = result["courseInfo"];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Thanh toán thành công: ${courseInfo['name']}!")),
      );

      // Điều hướng hoặc cập nhật trạng thái ứng dụng
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thanh toán thất bại, vui lòng thử lại.")),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    courseId = args['id'];
    token = args['token'];

    BlocProvider.of<CourseDetailBloc>(context).add(
      TriggerCourseDetails(courseId: courseId, token: token),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: reusableText("Course Detail"),
      ),
      body: BlocBuilder<CourseDetailBloc, CourseDetailStates>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          } else if (state.courseDetails == null) {
            return Center(child: Text('Không có thông tin khóa học'));
          } else {
            final course = state.courseDetails!;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    thumbNail(course['thumbnail']),
                    SizedBox(height: 15.h),
                    menuView(course['follow'], course['score']),
                    SizedBox(height: 15.h),
                    reusableText("Course Description"),
                    SizedBox(height: 15.h),
                    descriptionText(course['description']),
                    SizedBox(height: 20.h),
                    goBuyButton("Go buy", () => handlePayment(context)),
                    SizedBox(height: 20.h),
                    courseSummaryTitle(),
                    courseSummaryView(
                      context,
                      int.parse(
                          course['video_length'].toString()), // Số giờ video
                      int.parse(course['lesson_num'].toString()), // Số bài học
                      int.parse(course['download']
                          .toString()), // Tài nguyên có thể tải xuống
                    ),
                    SizedBox(height: 20.h),
                    reusableText("Lesson List"),
                    SizedBox(height: 20.h),
                    courseLessonList(course['name'], course['thumbnail']),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
