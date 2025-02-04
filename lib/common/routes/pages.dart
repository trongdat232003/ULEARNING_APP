import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/common/routes/names.dart';
import 'package:ulearning_app/common/service/chatService.dart';
import 'package:ulearning_app/common/service/courseService.dart';
import 'package:ulearning_app/page/application/application_page.dart';
import 'package:ulearning_app/page/application/bloc/app_blocs.dart';
import 'package:ulearning_app/global.dart';
import 'package:ulearning_app/page/chat/bloc/chat_blocs.dart';
import 'package:ulearning_app/page/chat/bloc/friends_bloc.dart';
import 'package:ulearning_app/page/chat/pages/chat_page.dart';
import 'package:ulearning_app/page/chat/pages/friend_list_page.dart';
import 'package:ulearning_app/page/course/bloc/couse_details_blocs.dart';
import 'package:ulearning_app/page/course/course_details.dart';
import 'package:ulearning_app/page/home/home_page.dart';
import 'package:ulearning_app/page/home/bloc/home_page_blocs.dart';
import 'package:ulearning_app/page/profile/settings/bloc/settings_blocs.dart';
import 'package:ulearning_app/page/profile/settings/settings_page.dart';
import 'package:ulearning_app/page/register/bloc/register_blocs.dart';
import 'package:ulearning_app/page/register/register.dart';
import 'package:ulearning_app/page/search/bloc/search_bloc.dart';
import 'package:ulearning_app/page/search/search_page.dart';
import 'package:ulearning_app/page/sign_in/bloc/sign_in_blocs.dart';
import 'package:ulearning_app/page/sign_in/sign_in.dart';
import 'package:ulearning_app/page/welcome/bloc/welcome_blocs.dart';
import 'package:ulearning_app/page/welcome/welcome.dart';

class AppPages {
  static List<PageEntity> routes() {
    return [
      PageEntity(
          route: AppRoutes.INITIAL,
          page: const Welcome(),
          bloc: BlocProvider(create: (_) => WelcomeBlocs())),
      PageEntity(
          route: AppRoutes.SIGN_IN,
          page: const SignIn(),
          bloc: BlocProvider(create: (_) => SignInBlocs())),
      PageEntity(
          route: AppRoutes.REGISTER,
          page: const Register(),
          bloc: BlocProvider(create: (_) => RegisterBlocs())),
      PageEntity(
          route: AppRoutes.APPLICATION,
          page: const ApplicationPage(),
          bloc: BlocProvider(create: (_) => AppBlocs())),
      PageEntity(
          route: AppRoutes.HOME_PAGE,
          page: const HomePage(),
          bloc: BlocProvider(create: (_) => HomePageBlocs())),
      PageEntity(
          route: AppRoutes.HOME_PAGE,
          page: const HomePage(),
          bloc: BlocProvider(create: (_) => HomePageBlocs())),
      PageEntity(
          route: AppRoutes.SETTINGS,
          page: const SettingsPage(),
          bloc: BlocProvider(create: (_) => SettingsBlocs())),
      PageEntity(
          route: AppRoutes.COURSE_DETAIL,
          page: const CourseDetails(),
          bloc: BlocProvider(create: (_) => CourseDetailBloc())),
      PageEntity(
        route: AppRoutes.SEARCH_PAGE,
        page: SearchPage(),
        bloc: BlocProvider(
            create: (_) => SearchBloc(courseService: CourseService())),
      ),
      PageEntity(
        route: AppRoutes.FRIEND_LIST_PAGE,
        page: FriendListPage(),
        bloc: BlocProvider(create: (_) => FriendListBloc()),
      ),
      PageEntity(
        route: AppRoutes.CHAT_PAGE,
        page: ChatPage(
          senderId: '', // Replace with sender ID dynamically
          receiverId: '', // Replace with receiver ID dynamically
        ),
        bloc: BlocProvider(create: (_) => ChatBloc(ChatService())),
      ),
    ];
  }

  static List<dynamic> allBlocProviders(BuildContext context) {
    List<dynamic> blocProviders = <dynamic>[];
    for (var bloc in routes()) {
      blocProviders.add(bloc.bloc);
    }
    return blocProviders;
  }

  //
  static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {
    if (settings.name != null) {
      //check for route name matching when navigator get triggered
      var result = routes().where((element) => element.route == settings.name);
      if (result.isNotEmpty) {
        bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();
        if (result.first.route == AppRoutes.INITIAL && deviceFirstOpen) {
          bool isLoggedIn = Global.storageService.getIsLoggedIn();
          if (isLoggedIn) {
            return MaterialPageRoute(
                builder: (_) => const ApplicationPage(), settings: settings);
          }
          return MaterialPageRoute(
              builder: (_) => SignIn(), settings: settings);
        }
        return MaterialPageRoute(
            builder: (_) => result.first.page, settings: settings);
      }
    }
    return MaterialPageRoute(
        builder: (_) => const SignIn(), settings: settings);
  }
}

// unify blocProvider  and routes and pages
class PageEntity {
  String route;
  Widget page;
  dynamic bloc;
  PageEntity({required this.route, required this.page, this.bloc});
}
