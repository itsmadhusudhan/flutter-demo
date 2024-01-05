import 'package:chatterbox/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import "dart:math" as math;

import 'package:chatterbox/navigation/app_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}

@RoutePage()
class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Camera");
  }
}

@RoutePage()
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Chat");
  }
}

class Flipper extends StatefulWidget {
  const Flipper({super.key, required this.front, required this.back});

  final Widget back;
  final Widget front;

  @override
  State<Flipper> createState() => _FlipperState();
}

class _FlipperState extends State<Flipper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: math.pi, end: 0.0).animate(animation);

    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, child) {
        final isUnder = (ValueKey(isFront) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder
            ? math.min(rotateAnim.value, math.pi / 2)
            : rotateAnim.value;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFront = !isFront;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: _transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        switchInCurve: Curves.easeInSine,
        switchOutCurve: Curves.easeInSine.flipped,
        child: isFront ? widget.front : widget.back,
      ),
    );
  }
}

@RoutePage()
class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (context, index) {
        return Flipper(
          front: Center(
            key: const ValueKey(true),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 450,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.red,
              ),
              child: Text("Status $index"),
            ),
          ),
          back: Center(
            key: const ValueKey(false),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 450,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.yellow,
              ),
              child: Text("Status $index"),
            ),
          ),
        );
      },
    );
  }
}

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Text("Hello"),
    // );

    return AutoTabsRouter.tabBar(
      routes: const [
        CameraRoute(),
        ConversationsRoute(),
        StatusRoute(),
      ],
      builder: (context, child, controller) {
        return Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (ctx, innerBoxIsScrolled) =>
                renderHeader(ctx, innerBoxIsScrolled, controller),
            body: child,
          ),
          floatingActionButton: Consumer(builder: (ctx, ref, widget) {
            return FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              focusColor: Theme.of(context).primaryColor,
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              child: const Icon(
                Icons.message,
                size: 28,
              ),
            );
          }),
        );
      },
    );
  }

  List<Widget> renderHeader(
      BuildContext context, bool innerBoxIsScrolled, TabController controller) {
    return [
      SliverAppBar(
        title: const Text(
          "ChatterBox",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        pinned: true,
        floating: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.camera_alt_outlined,
              size: 24,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.search_outlined,
            size: 24,
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.more_vert,
            size: 24,
          ),
          const SizedBox(width: 12),
        ],
        bottom: TabBar(
          controller: controller,
          indicatorSize: TabBarIndicatorSize.tab,
          unselectedLabelColor: Colors.white70,
          labelColor: Colors.white,
          indicatorWeight: 4,
          labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
          tabs: const [
            Tab(
              icon: Icon(Icons.cabin_outlined),
            ),
            Tab(
              child: Text(
                "Chats",
              ),
            ),
            Tab(
              child: Text(
                "Status",
              ),
            ),
          ],
        ),
      )
    ];
  }
}
