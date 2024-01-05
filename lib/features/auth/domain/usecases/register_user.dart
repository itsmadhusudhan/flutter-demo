import 'package:chatterbox/core/usecase.dart';
import 'package:chatterbox/features/auth/domain/repositories/user_repository.dart';

class RegisterUserUseCase implements UseCase<dynamic, Payload> {
  final UserRepository _userRepository;

  RegisterUserUseCase({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future invoke(params) {
    // TODO: implement invoke
    throw UnimplementedError();
  }
}

class Payload {
  final String email;
  final String password;

  Payload({required this.email, required this.password});
}
