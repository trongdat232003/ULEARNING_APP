abstract class SearchEvent {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  final String token; // Adding token to the event

  const SearchQueryChanged(this.query, this.token);

  @override
  List<Object?> get props => [query, token];
}
