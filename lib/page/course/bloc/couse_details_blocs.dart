import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/page/course/bloc/course_details_events.dart';
import 'package:ulearning_app/common/service/courseService.dart';
import 'package:ulearning_app/page/course/bloc/couse_details_states.dart'; // Đảm bảo đã import service lấy dữ liệu

class CourseDetailBloc extends Bloc<CourseDetailsEvents, CourseDetailStates> {
  CourseDetailBloc() : super(const CourseDetailStates()) {
    on<TriggerCourseDetails>(_triggerCourseDetails);
  }

  // Xử lý sự kiện TriggerCourseDetails
  Future<void> _triggerCourseDetails(
      TriggerCourseDetails event, Emitter<CourseDetailStates> emit) async {
    emit(state.copyWith(
        isLoading: true)); // Set loading state khi bắt đầu tải dữ liệu

    try {
      final courseDetails =
          await CourseService.getCourseDetails(event.courseId, event.token);

      if (courseDetails != null) {
        emit(state.copyWith(
            courseDetails: courseDetails,
            isLoading: false)); // Cập nhật khóa học và tắt loading
      } else {
        emit(state.copyWith(
            errorMessage: 'Course details not found.',
            isLoading: false)); // Hiển thị lỗi khi không tìm thấy khóa học
      }
    } catch (e) {
      print("Error fetching course details: $e");
      emit(state.copyWith(
          errorMessage: 'Failed to fetch course details',
          isLoading: false)); // Xử lý lỗi API
    }
  }
}
