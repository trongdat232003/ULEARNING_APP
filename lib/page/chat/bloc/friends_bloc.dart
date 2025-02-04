// friend_list_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/page/chat/bloc/friends_event.dart';
import 'package:ulearning_app/page/chat/bloc/friends_state.dart';
import 'package:ulearning_app/common/service/friendService.dart';
import 'package:ulearning_app/common/service/userService.dart';

class FriendListBloc extends Bloc<FriendListEvent, FriendListState> {
  FriendListBloc() : super(FriendListInitial());

  @override
  Stream<FriendListState> mapEventToState(FriendListEvent event) async* {
    if (event is LoadFriendsEvent) {
      yield FriendListLoading();

      String? token = await UserService.getToken();
      if (token == null) {
        yield FriendListError("Token không tồn tại!");
        return;
      }

      try {
        List<Map<String, dynamic>> friends =
            await FriendService.getFriends(token);
        yield FriendListLoaded(friends);
      } catch (e) {
        yield FriendListError("Lỗi khi tải danh sách bạn bè!");
      }
    }

    if (event is FriendRequestSentEvent) {
      String? token = await UserService.getToken();
      if (token == null) {
        yield FriendListError("Token không tồn tại!");
        return;
      }

      try {
        await FriendService.sendFriendRequest(event.receiverId, token);
        yield FriendListLoading(); // Keep loading until the list is refreshed
        add(LoadFriendsEvent()); // Reload friends after sending the request
      } catch (e) {
        yield FriendListError("Lỗi khi gửi lời mời kết bạn!");
      }
    }
  }
}
