import 'package:auto_route/auto_route.dart';
import 'package:chatterbox/features/auth/presentation/provider/auth_provider.dart';
import 'package:chatterbox/navigation/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard extends AutoRouteGuard {
  final ProviderRef ref;

  AuthGuard({
    required this.ref,
  });

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final state = ref.read(authProvider);

    if (state.isLoggedIn) {
      router.replaceNamed(AppRoutes.homePage);
    } else {
      resolver.next(true);
    }
  }
}

class LoginGuard extends AutoRouteGuard {
  final ProviderRef ref;

  LoginGuard({
    required this.ref,
  });

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final state = ref.read(authProvider);

    print("Gor here too");

    print(state.isLoggedIn);
    print(router.currentPath);

    if (!state.isLoggedIn) {
      print("I tried2");
      router.replaceNamed("/auth");
    } else {
      resolver.next(true);
    }

    // if (!resolver.isReevaluating) {
    //   state.isLoggedIn ? resolver.next(true) : router.replaceNamed("/auth");
    // } else {
    //   resolver.next(true);
    // }
  }
}
