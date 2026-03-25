import 'package:smart_lunch/data/models/user_model.dart';

class DebtorsResponse {
  final double totalDebt;
  final List<UserModel> users;

  DebtorsResponse({
    required this.totalDebt,
    required this.users,
  });
}
