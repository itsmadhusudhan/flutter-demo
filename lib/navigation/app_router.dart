import 'package:auto_route/auto_route.dart';

import 'package:chatterbox/features/auth/barrel.dart';
import 'package:chatterbox/features/conversation/barrel.dart';
import 'package:chatterbox/features/home/home_page.dart';
import 'package:chatterbox/features/message/barrel.dart';
import 'package:chatterbox/navigation/auth_guard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './routes.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  final ProviderRef ref;

  AppRouter({
    super.navigatorKey,
    required this.ref,
  });

  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: AuthRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
          path: "/auth",
          children: [
            RedirectRoute(path: '', redirectTo: 'login'),
            CustomRoute(
              page: LoginRoute.page,
              path: AppRoutes.loginPage,
              transitionsBuilder: TransitionsBuilders.noTransition,
              children: [
                CustomRoute(
                  page: DetailsRoute.page,
                  path: "detail",
                  transitionsBuilder: TransitionsBuilders.fadeIn,
                ),
              ],
            ),
          ],
        ),
        CustomRoute(
            page: RootRoute.page,
            path: AppRoutes.rootPage,
            transitionsBuilder: TransitionsBuilders.noTransition,
            initial: true,
            children: [
              AutoRoute(
                initial: true,
                page: HomeRoute.page,
                path: AppRoutes.homePage,
                children: [
                  AutoRoute(
                    guards: [LoginGuard(ref: ref)],
                    page: CameraRoute.page,
                    path: AppRoutes.cameraPage,
                  ),
                  AutoRoute(
                    initial: true,
                    page: ConversationsRoute.page,
                  ),
                  AutoRoute(
                    page: StatusRoute.page,
                  ),
                ],
              ),
              AutoRoute(
                page: MessagesRoute.page,
                path: AppRoutes.messagesPage,
              ),
            ]),
      ];
}
