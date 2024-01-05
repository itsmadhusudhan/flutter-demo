import 'package:chatterbox/features/auth/data/token_repository.dart';
import 'package:chatterbox/features/auth/data/user_repository.dart';
import 'package:chatterbox/injectable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './auth_notifier.dart';

// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
//   (ref) => AuthNotifier(
//     tokenRepository: getIt<ITokenRepository>(),
//     userRepository: getIt<IUserRepository>(),
//   ),
// );

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    tokenRepository: getIt<ITokenRepository>(),
    userRepository: getIt<IUserRepository>(),
  ),
);
