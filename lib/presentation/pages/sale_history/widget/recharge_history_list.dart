import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_lunch/blocs/history/history_bloc.dart';
import 'package:smart_lunch/blocs/history/history_event.dart';
import 'package:smart_lunch/blocs/history/history_state.dart';
import 'package:smart_lunch/core/base_widgets/cards/empty_products_state.dart';
import 'package:smart_lunch/core/base_widgets/cards/sale_card.dart';
import 'package:smart_lunch/data/models/recharge_history_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

/// Lista de recargas del historial, filtrada por [periodo]
/// ('todo', 'hoy' o 'este_mes') según lo seleccionado en el
/// [OrangeSelector] de HistoryPage.
class RechargeHistoryList extends StatefulWidget {
  const RechargeHistoryList({super.key, this.periodo = 'todo'});

  final String periodo;

  @override
  State<RechargeHistoryList> createState() => _RechargeHistoryListState();
}

class _RechargeHistoryListState extends State<RechargeHistoryList> {
  String? _expandedId;

  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadHistoryEvent());
  }

  bool _matchesPeriodo(RechargeHistory recarga) {
    if (widget.periodo == 'todo') return true;

    final DateTime? fecha = recarga.rechargeDate != null
        ? DateFormat('dd/MM/yyyy').tryParse(recarga.rechargeDate!)
        : null;
    if (fecha == null) return false;

    final now = DateTime.now();
    final esMismoMes = fecha.year == now.year && fecha.month == now.month;

    if (widget.periodo == 'hoy') {
      return esMismoMes && fecha.day == now.day;
    }
    if (widget.periodo == 'este_mes') {
      return esMismoMes;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading || state is HistoryInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HistoryError) {
          return Center(child: Text(state.message));
        }

        final recargas = (state as HistoryLoaded)
            .rechargeHistory
            .where(_matchesPeriodo)
            .toList();

        if (recargas.isEmpty) {
          return EmptyProductsState(
            message: AppLocalizations.of(context)!.no_recharges_message,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: recargas.length,
          itemBuilder: (context, index) {
            final recarga = recargas[index];
            return SaleCard(
              name: recarga.rechargeUser ?? '',
              date: recarga.rechargeDate ?? '',
              amount: double.tryParse(recarga.total ?? '') ?? 0,
              id: recarga.id ?? '',
              saleType:
                  recarga.platform ??
                  AppLocalizations.of(context)!.recharge_message,
              time: recarga.rechargeTime ?? '',
              showProducts: false,
              expanded: _expandedId == recarga.id,
              onExpansionChanged: (isExpanded) {
                setState(() => _expandedId = isExpanded ? recarga.id : null);
              },
            );
          },
        );
      },
    );
  }
}
