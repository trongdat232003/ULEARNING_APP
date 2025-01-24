import 'package:bloc/bloc.dart';
import 'package:ulearning_app/common/service/courseService.dart'; // Import the service
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CourseService courseService;

  SearchBloc({required this.courseService}) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final courses =
          await CourseService.searchCourses(event.token, event.query);
      emit(SearchLoaded(courses));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
