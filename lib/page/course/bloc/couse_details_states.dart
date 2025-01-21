class CourseDetailStates {
  final Map<String, dynamic>? courseDetails;
  final bool isLoading;
  final String? errorMessage;

  const CourseDetailStates({
    this.courseDetails,
    this.isLoading = false,
    this.errorMessage,
  });

  // Hàm copyWith để sao chép và cập nhật trạng thái
  CourseDetailStates copyWith({
    Map<String, dynamic>? courseDetails,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CourseDetailStates(
      courseDetails: courseDetails ?? this.courseDetails,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
