import 'package:smart_lunch/core/constants/user_roles.dart';

class SessionData {
  final String? accessToken;
  final String? refreshToken;
  final String? cafeteriaId;
  final String? userId;
  final UserRole? userType;
  final String? familyId;
  String? openpayId;

  SessionData({
    required this.accessToken,
    required this.refreshToken,
    required this.cafeteriaId,
    required this.userId,
    required this.userType,
    required this.familyId,
    this.openpayId,
  });

  SessionData copyWith({
    String? accessToken,
    String? refreshToken,
    String? cafeteriaId,
    String? userId,
    UserRole? userType,
    String? familyId,
    String? openpayId,
  }) {
    return SessionData(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      cafeteriaId: cafeteriaId ?? this.cafeteriaId,
      userId: userId ?? this.userId,
      userType: userType ?? this.userType,
      familyId: familyId ?? this.familyId,
      openpayId: openpayId ?? this.openpayId,
    );
  }
}