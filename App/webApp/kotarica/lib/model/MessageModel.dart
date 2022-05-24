import 'UserModel.dart';

class Message {
  final User sender;
  final String time;
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}

List<Message> chats = [
  Message(sender: user1, time: '15:56', text: 'Zdravo!', unread: true),
  Message(sender: user2, time: '13:00', text: 'Zdravo!', unread: true),
  Message(sender: user3, time: '11:23', text: 'Zdravo!', unread: false),
  Message(sender: user4, time: '19:08', text: 'Zdravo!', unread: true),
  Message(sender: user5, time: '02:45', text: 'Zdravo!', unread: false),
];

List<Message> messages = [
  Message(sender: currentUser, time: '15:56', text: 'Zdravo!', unread: true),
  Message(sender: user1, time: '13:00', text: 'Zdravo!', unread: true),
  Message(sender: currentUser, time: '11:23', text: 'Zdravo!', unread: true),
  Message(sender: user1, time: '19:08', text: 'Zdravo!', unread: true),
  Message(sender: currentUser, time: '02:45', text: 'Zdravo!', unread: true),
  Message(sender: user1, time: '02:45', text: 'Zdravo!', unread: true),
  Message(sender: currentUser, time: '15:16', text: 'Zdravo!', unread: true),
  Message(sender: user1, time: '13:05', text: 'Zdravo!', unread: true),
  Message(sender: currentUser, time: '11:43', text: 'Zdravo!', unread: true),
  Message(sender: user1, time: '19:00', text: 'Zdravo!', unread: true),
  Message(sender: currentUser, time: '02:55', text: 'Zdravo!', unread: true),
  Message(sender: user1, time: '02:49', text: 'Zdravo!', unread: true),
];
