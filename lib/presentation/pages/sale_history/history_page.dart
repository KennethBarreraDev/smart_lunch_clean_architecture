import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_bloc.dart';
import 'package:smart_lunch/blocs/app_version/app_version_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/base_widgets/selector/orange_selector.dart';
import 'package:smart_lunch/core/base_widgets/tabs_reutilizables/tab_orange_filter.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';
import 'package:smart_lunch/presentation/pages/sale_history/widget/recharge_history_list.dart';
import 'package:smart_lunch/presentation/pages/sale_history/widget/sales_history_list.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _periodoSeleccionado = 'todo';

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppVersionBloc, AppVersionState>(
          listener: (context, state) {
            //TODO: Show version modal
            /*
            showDialog(
              context: context,
              useSafeArea: true,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AppVersionModal();
              },
            );*/
          },
        ),
      ],
      child: TransparentScaffold(
        selectedOption: "Historial",
        body: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(
                  height: 120,
                  image: AppImages.cardImg,
                  showPageTitle: true,
                  pageTitle: AppLocalizations.of(context)!.history,
                  showDrawer: true,
                  showSchoolLogo: false,
                  hideGoBackText: false,
                  titleAlignment: Alignment.bottomLeft,
                  titleTopPadding: 0.4,
                  titleSize: 28.0,
                ),

                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: OrangeSelector<String>(
                      etiquetas: [
                        AppLocalizations.of(context)!.filter_all,
                        AppLocalizations.of(context)!.filter_today,
                        AppLocalizations.of(context)!.filter_this_month,
                      ],
                      valores: const ['todo', 'hoy', 'este_mes'],
                      valor: _periodoSeleccionado,
                      onChanged: (valor) {
                        setState(() => _periodoSeleccionado = valor);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: TabOrangeFilter(
                    tabs: [
                      AppLocalizations.of(context)!.sale,
                      AppLocalizations.of(context)!.recharges,
                    ],
                    views: [
                      SalesHistoryList(periodo: _periodoSeleccionado),
                      RechargeHistoryList(periodo: _periodoSeleccionado),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
