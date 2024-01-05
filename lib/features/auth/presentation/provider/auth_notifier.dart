import 'dart:async';

import 'package:chatterbox/features/auth/data/token_repository.dart';
import 'package:chatterbox/features/auth/data/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;

  AuthState({required this.isLoggedIn, required this.isLoading});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ITokenRepository _tokenRepository;
  final IUserRepository _userRepository;
  late final StreamSubscription<TokenState?> _tokenStream;

  AuthNotifier({
    required ITokenRepository tokenRepository,
    required IUserRepository userRepository,
  })  : _tokenRepository = tokenRepository,
        _userRepository = userRepository,
        super(AuthState(isLoggedIn: false, isLoading: false)) {
    _tokenStream = _tokenRepository.accessToken.listen((tokenState) {
      if (tokenState is TokenState) {
        state = AuthState(isLoggedIn: true, isLoading: false);
      } else {
        state = AuthState(isLoggedIn: false, isLoading: false);
      }
    });
  }

  @override
  void dispose() {
    _tokenStream.cancel();
    super.dispose();
  }

  loginWithEmail() {
    state = AuthState(isLoading: true, isLoggedIn: state.isLoggedIn);

    Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      state = AuthState(isLoggedIn: true, isLoading: false);
    });
  }

  logout() {
    state = AuthState(isLoggedIn: false, isLoading: false);
  }

  initialise() async {
    String? accessToken = await _tokenRepository.getAccessToken();
    // String? refreshToken = await tokenRepository.getRefreshToken();
    if (accessToken != null) {
      state = AuthState(isLoggedIn: true, isLoading: false);
    }
  }
}
