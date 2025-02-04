import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/common/routes/names.dart';
import 'package:ulearning_app/common/service/courseService.dart';
import 'package:ulearning_app/common/service/userService.dart';
import 'package:ulearning_app/page/search/bloc/search_bloc.dart';
import 'package:ulearning_app/page/search/bloc/search_event.dart';
import 'package:ulearning_app/page/search/bloc/search_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Courses",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error: Unable to fetch token.'));
          } else {
            final token = snapshot.data!;
            return BlocProvider(
              create: (context) => SearchBloc(courseService: CourseService()),
              child: SearchBody(token: token, controller: _controller),
            );
          }
        },
      ),
    );
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

class SearchBody extends StatelessWidget {
  final String token;
  final TextEditingController controller;

  SearchBody({required this.token, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search for courses...',
              hintStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: Colors.white24,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (query) {
              context.read<SearchBloc>().add(SearchQueryChanged(query, token));
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is SearchLoaded) {
                return ListView.builder(
                  itemCount: state.courses.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            state.courses[index]['thumbnail'] ?? '',
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          state.courses[index]['name'] ?? 'No name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(
                            state.courses[index]['description'] ??
                                'No description',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        trailing: Text(
                          '\$${state.courses[index]['price']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 16.0,
                          ),
                        ),
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
                      ),
                    );
                  },
                );
              } else if (state is SearchError) {
                return Center(child: Text('Error: ${state.error}'));
              }
              return Center(child: Text('Start searching...'));
            },
          ),
        ),
      ],
    );
  }
}
