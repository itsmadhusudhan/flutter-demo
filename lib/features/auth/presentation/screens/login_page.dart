import 'package:auto_route/auto_route.dart';
import 'package:chatterbox/core/network/connection_status.dart';
import 'package:chatterbox/features/auth/presentation/provider/auth_provider.dart';
import 'package:chatterbox/injectable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

final connectionStatusProvider = StreamProvider((ref) {
  return getIt<ConnectionStatusSingleton>().connectionChange;
});

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: AutoRouter(),
        ),
      ],
    );
  }
}

@RoutePage()
class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        children: [
          const Center(
            child: Text("Hello Details"),
          ),
          ElevatedButton(
            onPressed: () {
              AutoRouter.of(context).parent()?.pop();
            },
            child: const Text('Pop'),
          ),
        ],
      ),
    );
  }
}

class Todo {
  final int id;
  final String title;
  final bool? completed;
  final String? body;

  Todo({
    required this.id,
    required this.title,
    this.completed,
    this.body,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool?,
      body: json['body'] as String?,
    );
  }
}

@RoutePage()
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final status = ref.watch(connectionStatusProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      // body: newMethod(status, context),
      body: ResponsiveRowColumn(
        columnSpacing: 20,
        layout: ResponsiveValue(
          context,
          conditionalValues: [
            Condition.largerThan(
              value: ResponsiveRowColumnType.ROW,
              name: TABLET,
            ),
          ],
          defaultValue: ResponsiveRowColumnType.COLUMN,
        ).value!,
        children: [
          ResponsiveRowColumnItem(
            child: Center(
              child: Column(
                children: [
                  ResponsiveVisibility(
                    visible: true,
                    visibleConditions: [
                      Condition.smallerThan(
                        name: TABLET,
                        value: false,
                      ),
                    ],
                    child: Text(
                      'Login Page is ${status.value ?? false ? "connected" : "not connected"}',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).loginWithEmail();
                      // AutoRouter.of(context).pushNamed("/");
                    },
                    child: const Text('Login'),
                  ),
                  if (authState.isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
