import 'package:auto_route/auto_route.dart';
import 'package:chatterbox/features/auth/presentation/provider/auth_provider.dart';
import 'package:chatterbox/navigation/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

final routeProvider = Provider((ref) {
  return AppRouter(ref: ref);
});

class ChatterBox extends ConsumerStatefulWidget {
  const ChatterBox({super.key});

  @override
  ConsumerState<ChatterBox> createState() => _ChatterBoxState();
}

class _ChatterBoxState extends ConsumerState<ChatterBox> {
  @override
  Widget build(BuildContext context) {
    final appRouter = ref.read(routeProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp.router(
      title: 'Chatter Box',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF13C16D)),
        useMaterial3: true,
        fontFamily: GoogleFonts.roboto().fontFamily,
      ),
      routerDelegate: AutoRouterDelegate.declarative(
        appRouter,
        routes: (handler) {
          if (authState.isLoggedIn) {
            return [
              const RootRoute(),
            ];
          }

          return [const LoginRoute()];
        },
      ),
      routeInformationParser:
          appRouter.defaultRouteParser(includePrefixMatches: true),
      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          breakpoints: [
            // define breakpoints
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: child!,
        );
      },
    );
  }
}
