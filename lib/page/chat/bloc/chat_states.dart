abstract class ChatState {}

class ChatInitial extends ChatState {}

class MessageSent extends ChatState {}

class MessageReceived extends ChatState {
  final String message;
  MessageReceived(this.message);
}
