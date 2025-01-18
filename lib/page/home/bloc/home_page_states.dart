class HomePageStates {
  final int index;
  final List<dynamic> courses; // Danh sách khóa học

  HomePageStates({this.index = 0, this.courses = const []});

  HomePageStates copyWith({int? index, List<dynamic>? courses}) {
    return HomePageStates(
      index: index ?? this.index,
      courses: courses ?? this.courses,
    );
  }
}
