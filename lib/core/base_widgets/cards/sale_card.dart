import 'package:flutter/material.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

/// Modelo reducido de producto para mostrar dentro de la tarjeta de venta.
class ShortProduct {
  final String name;
  final int quantity;
  final double price;

  const ShortProduct({
    required this.name,
    required this.quantity,
    required this.price,
  });
}

/// Tarjeta de venta expandible
/// - Ventas de productos: `showProducts = true` y pasar la lista.
/// - Recargas: `showProducts = false`, se oculta la tabla completa.


class SaleCard extends StatefulWidget {
  final String name;
  final String date;
  final double amount;
  final String id;
  final String saleType;
  final String time;

  final bool showProducts;
  final List<ShortProduct> products;
  final bool initiallyExpanded;

  /// Si se provee, la tarjeta pasa a modo controlado: [expanded] decide si
  /// se muestran los detalles y [onExpansionChanged] se dispara al tocar el
  /// botón, en lugar de que la tarjeta maneje su propio estado interno.
  /// Útil para que una lista permita solo una tarjeta abierta a la vez.
  final bool? expanded;
  final ValueChanged<bool>? onExpansionChanged;

  const SaleCard({
    super.key,
    required this.name,
    required this.date,
    required this.amount,
    required this.id,
    required this.saleType,
    required this.time,
    this.showProducts = true,
    this.products = const [],
    this.initiallyExpanded = false,
    this.expanded,
    this.onExpansionChanged,
  });

  @override
  State<SaleCard> createState() => _SaleCardState();
}

class _SaleCardState extends State<SaleCard> {
  late bool _expanded = widget.initiallyExpanded;

  static const _textColor = Color(0xFF2B2B2B);
  static const _secondaryColor = Color(0xFF9A9A9A);

  bool get _isExpanded => widget.expanded ?? _expanded;

  void _toggle() {
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(!_isExpanded);
    } else {
      setState(() => _expanded = !_expanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card(child: _header()),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _card(child: _details()),
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Parte superior: nombre, fecha, monto y expandir
  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.date,
                style: const TextStyle(fontSize: 14, color: _secondaryColor),
              ),
            ],
          ),
        ),
        Text(
          '\$${widget.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: _textColor,
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: _toggle,
          customBorder: const CircleBorder(),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            child: AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 220),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: _secondaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// datos de compra solo a productos tabla de productos.
  Widget _details() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(flex: 4, child: _field('ID', widget.id)),
            Expanded(
              flex: 4,
              child: _field(l10n.sale_type, widget.saleType),
            ),
            Expanded(
              flex: 3,
              child: _field(l10n.time, widget.time, align: CrossAxisAlignment.end),
            ),
          ],
        ),
        if (widget.showProducts) ...[
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(flex: 5, child: _Label(l10n.product_message)),
              Expanded(
                flex: 3,
                child: _Label(l10n.amount_message, align: TextAlign.center),
              ),
              Expanded(
                flex: 3,
                child: _Label(l10n.price_message, align: TextAlign.end),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _DashedDivider(),
          const SizedBox(height: 14),
          ...widget.products.map(_productRow),
        ],
      ],
    );
  }

  /// Par etiqueta/valor usado en la fila de ID, tipo de venta y hora
  Widget _field(
    String label,
    String value, {
    CrossAxisAlignment align = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: _secondaryColor),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
      ],
    );
  }

  Widget _productRow(ShortProduct product) {
    const style = TextStyle(fontSize: 17, color: _secondaryColor);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(product.name, style: style)),
          Expanded(
            flex: 3,
            child: Text(
              '${product.quantity}',
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '\$${product.price.toStringAsFixed(0)}',
              textAlign: TextAlign.end,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}

/// Encabezado de pructos
class _Label extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _Label(this.text, {this.align = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(fontSize: 16, color: Color(0xFF6E6E6E)),
    );
  }
}

/// Línea punteada que separa el encabezado de la tabla de los productos.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 8.0;
        const dashSpace = 6.0;
        final dashCount = (constraints.maxWidth / (dashWidth + dashSpace))
            .floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (_) => Container(
              width: dashWidth,
              height: 1.5,
              color: const Color(0xFFCFCFCF),
            ),
          ),
        );
      },
    );
  }
}
