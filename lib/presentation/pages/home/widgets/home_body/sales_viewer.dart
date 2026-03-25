import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_bloc.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_event.dart';
import 'package:smart_lunch/core/base_widgets/sale_list/tab_content.dart';
import 'package:smart_lunch/core/utils/app_colors.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/data/models/cafeteria_user_model.dart';
import 'package:smart_lunch/data/models/presale_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class SalesViewer extends StatelessWidget {
  const SalesViewer({
    super.key,
    required this.mainUser,
    required this.dailySales,
    required this.presales,
    required this.cafeteria,
  });

  final CafeteriaUser mainUser;
  final List<Presale> dailySales;
  final List<Presale> presales;
  final Cafeteria? cafeteria;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          ColoredBox(
            color: AppColors.white,
            child: TabBar(
              dividerColor: Colors.transparent,
              labelColor: AppColors.orange,
              unselectedLabelColor: AppColors.orange.withValues(alpha: 0.5),
              indicatorColor: AppColors.orange,
              labelPadding: EdgeInsets.zero,
              tabs: [
                Tab(text: AppLocalizations.of(context)!.today_purchases),
                Tab(text: AppLocalizations.of(context)!.presales),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<SalesHistoryBloc>().add(LoadSalesHistoryEvent(mainUser));
                    },
                    child: TabContent(
                      isPresale: false,
                      products: dailySales,
                      cafeteria: cafeteria,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<SalesHistoryBloc>().add(LoadSalesHistoryEvent(mainUser));
                    },
                    child: TabContent(
                      isPresale: true,
                      products: presales,
                      cafeteria: cafeteria,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
