abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String message;

  SendMessageEvent(this.senderId, this.receiverId, this.message);
}

class ReceiveMessageEvent extends ChatEvent {
  final String message;

  ReceiveMessageEvent(this.message);
}
