import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/common/service/courseService.dart';
import 'package:ulearning_app/common/service/userService.dart';
import 'package:ulearning_app/page/home/bloc/home_page_events.dart';
import 'package:ulearning_app/page/home/bloc/home_page_states.dart';

class HomePageBlocs extends Bloc<HomePageEvents, HomePageStates> {
  HomePageBlocs() : super(HomePageStates()) {
    on<HomePageDots>(_homePageDots);
    on<LoadCourses>(_loadCourses); // Xử lý sự kiện tải danh sách khóa học
  }

  void _homePageDots(HomePageDots event, Emitter<HomePageStates> emit) {
    emit(state.copyWith(index: event.index));
  }

  Future<void> _loadCourses(
      LoadCourses event, Emitter<HomePageStates> emit) async {
    try {
      String? token = await UserService.getToken();
      if (token != null) {
        final courses = await CourseService.getListCourse(token);
        emit(state.copyWith(courses: courses));
      } else {
        print('No token found');
      }
    } catch (e) {
      print("Error loading courses: $e");
    }
  }
}
