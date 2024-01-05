import 'package:auto_route/auto_route.dart';
import 'package:chatterbox/core/network/api_client.dart';
import 'package:chatterbox/features/auth/presentation/screens/login_page.dart';
import 'package:chatterbox/injectable.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

@RoutePage()
class MessagesScreen extends StatelessWidget {
  MessagesScreen({super.key});

  final builder = FutureBuilder(
    future: getIt<ApiClient>().get("/posts").then((value) => value.data),
    builder: (ctx, data) {
      if (data.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final values =
          (data.data as List<dynamic>).map((e) => Todo.fromJson(e)).toList();

      return ListView.builder(
        itemCount: values.length,
        itemBuilder: (ctx, index) {
          final value = values.elementAt(index);
          return MouseRegion(
            child: ListTile(
              key: Key(value.id.toString()),
              title: Text(value.title),
              subtitle: ResponsiveValue(ctx,
                      conditionalValues: [
                        Condition.smallerThan(
                          name: TABLET,
                          value: const Text("Hello All"),
                        ),
                      ],
                      defaultValue: Text(value.body.toString()))
                  .value!,
              onTap: () {
                print(value.title);
              },
            ),
          );
        },
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  context.router.pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 28,
                )),
            const SizedBox(
              width: 12,
            ),
            // CircleAvatar(
            //   radius: 20,
            //   backgroundColor: Colors.orange,
            //   foregroundColor: Colors.white,
            //   child: Icon(
            //     Icons.person,
            //     size: 28,
            //   ),
            // ),
            const SizedBox(
              width: 12,
            ),
            const Text(
              "Messages",
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.videocam_rounded,
              size: 24,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.phone,
            size: 24,
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.more_vert,
            size: 24,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: builder,
    );
  }
}
