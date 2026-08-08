import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_bloc.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_event.dart';
import 'package:smart_lunch/blocs/sales_history/sales_history_state.dart';
import 'package:smart_lunch/blocs/users/users_bloc.dart';
import 'package:smart_lunch/blocs/users/users_state.dart';
import 'package:smart_lunch/core/base_widgets/cards/empty_products_state.dart';
import 'package:smart_lunch/core/base_widgets/cards/sale_card.dart';
import 'package:smart_lunch/data/models/presale_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class _SaleEntry {
  final Presale venta;
  final bool isPresale;

  const _SaleEntry(this.venta, this.isPresale);
}

/// Lista de ventas del historial, filtrada por [periodo]
/// ('todo', 'hoy' o 'este_mes') según lo seleccionado en el
/// [OrangeSelector] de HistoryPage.
class SalesHistoryList extends StatefulWidget {
  const SalesHistoryList({super.key, this.periodo = 'todo'});

  final String periodo;

  @override
  State<SalesHistoryList> createState() => _SalesHistoryListState();
}

class _SalesHistoryListState extends State<SalesHistoryList> {
  String? _expandedId;

  @override
  void initState() {
    super.initState();
    final usersState = context.read<UsersBloc>().state;
    if (usersState is UsersLoaded) {
      context.read<SalesHistoryBloc>().add(
            LoadSalesHistoryEvent(usersState.mainUser),
          );
    }
  }

  bool _matchesPeriodo(String fechaTexto) {
    if (widget.periodo == 'todo') return true;

    final DateTime? fecha = DateFormat('dd/MM/yyyy').tryParse(fechaTexto);
    if (fecha == null) return false;

    final now = DateTime.now();
    final esMismoMes = fecha.year == now.year && fecha.month == now.month;

    if (widget.periodo == 'hoy') {
      return esMismoMes && fecha.day == now.day;
    }
    return esMismoMes; // este_mes
  }

  List<ShortProduct> _toShortProducts(Presale venta) {
    return venta.products
        .map(
          (p) => ShortProduct(
            name: p.productName,
            quantity: p.amount,
            price: p.price,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesHistoryBloc, SalesHistoryState>(
      builder: (context, state) {
        if (state is SalesHistoryLoading || state is SalesHistoryInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SalesHistoryError) {
          return Center(child: Text(state.message));
        }

        final loaded = state as SalesHistoryLoaded;
        final ventas = [
          ...loaded.sales.map((v) => _SaleEntry(v, false)),
          ...loaded.presales.map((v) => _SaleEntry(v, true)),
        ].where((entry) => _matchesPeriodo(entry.venta.deliveryDate)).toList();

        if (ventas.isEmpty) {
          return EmptyProductsState(
            message: AppLocalizations.of(context)!.no_sales_message,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: ventas.length,
          itemBuilder: (context, index) {
            final entry = ventas[index];
            final venta = entry.venta;
            return SaleCard(
              name: venta.childName,
              date: venta.deliveryDate,
              amount: venta.saleTotal,
              id: venta.presaleId,
              saleType: entry.isPresale
                  ? AppLocalizations.of(context)!.presale
                  : AppLocalizations.of(context)!.direct_sale_message,
              time: '',
              products: _toShortProducts(venta),
              expanded: _expandedId == venta.presaleId,
              onExpansionChanged: (isExpanded) {
                setState(
                  () => _expandedId = isExpanded ? venta.presaleId : null,
                );
              },
            );
          },
        );
      },
    );
  }
}
