// friend_list_event.dart
abstract class FriendListEvent {}

class LoadFriendsEvent extends FriendListEvent {}

class FriendRequestSentEvent extends FriendListEvent {
  final String receiverId;

  FriendRequestSentEvent(this.receiverId);
}
