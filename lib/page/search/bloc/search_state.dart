abstract class SearchState {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<dynamic> courses;

  const SearchLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}

class SearchError extends SearchState {
  final String error;

  const SearchError(this.error);

  @override
  List<Object?> get props => [error];
}
