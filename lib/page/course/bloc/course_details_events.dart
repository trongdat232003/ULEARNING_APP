abstract class CourseDetailsEvents {
  const CourseDetailsEvents();
}

class TriggerCourseDetails extends CourseDetailsEvents {
  final String courseId;
  final String token;

  const TriggerCourseDetails({
    required this.courseId,
    required this.token,
  });
}
