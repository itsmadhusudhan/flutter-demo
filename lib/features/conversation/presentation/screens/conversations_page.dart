import 'package:chatterbox/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class ChatTile extends StatelessWidget {
  final String title;
  final String subtitle;
  // add onllongpress and ontap

  final Function()? onTap;
  final Function()? onLongPress;
  final Widget? leading;

  const ChatTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onLongPress,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.person,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
      minVerticalPadding: 10,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

@RoutePage()
class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      itemCount: 250,
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: ChatTile(
            onTap: () {
              print("clciked");
              context.router.pushNamed(AppRoutes.messagesPage);
            },
            title: 'Madhusudhan',
            subtitle: "hello all",
          ),
        );
      },
      //physics: NeverScrollableScrollPhysics(),
    );
  }
}
