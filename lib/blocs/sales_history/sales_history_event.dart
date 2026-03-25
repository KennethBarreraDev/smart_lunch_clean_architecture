import 'package:smart_lunch/data/models/cafeteria_user_model.dart';

abstract class SalesHistoryEvent {
}

class LoadSalesHistoryEvent extends SalesHistoryEvent {
  CafeteriaUser user;
  LoadSalesHistoryEvent(this.user);
}
