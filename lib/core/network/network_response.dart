import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_response.freezed.dart';

@freezed
class NetworkResponse<T> with _$NetworkResponse<T> {
  const factory NetworkResponse.success(T data) = Ok<T>;
  const factory NetworkResponse.error(String message) = ERROR;
  const factory NetworkResponse.loading() = LOADING;
}
