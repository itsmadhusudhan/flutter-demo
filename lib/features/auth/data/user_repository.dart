import 'package:chatterbox/core/network/api_client.dart';
import 'package:injectable/injectable.dart';

abstract class IUserRepository {
  Future signInWithEmail({
    required String email,
    required String password,
  });
  Future signupWithEmail({
    required String email,
    required String password,
  });
}

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final ApiClient apiClient;

  UserRepository({required this.apiClient});

  @override
  Future signInWithEmail({required String email, required String password}) {
    // TODO: implement signInWithEmail
    throw UnimplementedError();
  }

  @override
  Future signupWithEmail({required String email, required String password}) {
    // TODO: implement signupWithEmail
    throw UnimplementedError();
  }
}
