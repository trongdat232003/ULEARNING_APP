import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/common/service/chatService.dart';
import 'package:ulearning_app/page/chat/bloc/chat_events.dart';
import 'package:ulearning_app/page/chat/bloc/chat_states.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService chatService;

  ChatBloc(this.chatService) : super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      // Send message through the service (Socket.IO)
      chatService.sendMessage(event.senderId, event.receiverId, event.message);
      emit(MessageSent());
    });

    on<ReceiveMessageEvent>((event, emit) {
      // When message is received, update the UI state
      emit(MessageReceived(event.message));
    });
  }
}
