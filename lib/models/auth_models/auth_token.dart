import 'package:json_annotation/json_annotation.dart';

part 'auth_token.g.dart';

@JsonSerializable()
class AuthToken {
  @JsonKey(name: 'accessToken')
  String? accessToken;

  @JsonKey(name: 'refreshToken')
  String? refreshToken;

  AuthToken({
    this.accessToken,
    this.refreshToken,
  });

  /// Factory constructor for creating a new instance from a JSON map
  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);

  /// Method to convert this object into a JSON map
  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);
}
