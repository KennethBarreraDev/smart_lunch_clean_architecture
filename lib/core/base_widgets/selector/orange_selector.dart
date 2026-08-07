import 'package:flutter/material.dart';

class OrangeSelector<T> extends StatefulWidget {
  OrangeSelector({
    super.key,
    required this.etiquetas,
    required this.valores,
    required this.valor,
    required this.onChanged,
    this.ancho = 200,
    this.alto = 44,
    this.colorFondo = const Color(0xFFFAEAE0),
    this.colorTexto = const Color(0xFFF5A26B),
  }) : assert(
         etiquetas.length == valores.length,
         'etiquetas y valores deben tener la misma longitud',
       ),
       assert(valores.isNotEmpty, 'se requiere al menos una opción'),
       assert(
         valores.contains(valor),
         'valor debe existir dentro de la lista valores',
       );

  /// Textos en el mismo orden que [valores]
  final List<String> etiquetas;

  /// Valores en el mismo orden que [etiquetas]
  final List<T> valores;

  /// Valor seleccionado actualmente
  final T valor;

  final ValueChanged<T> onChanged;
  final double ancho;
  final double alto;
  final Color colorFondo;
  final Color colorTexto;

  @override
  State<OrangeSelector<T>> createState() =>
      _OrangeSelectorState<T>();
}

class _OrangeSelectorState<T>
    extends State<OrangeSelector<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _link = LayerLink();
  OverlayEntry? _overlay;
  late final AnimationController _controller;
  late final Animation<double> _curva;

  String get _etiquetaActual =>
      widget.etiquetas[widget.valores.indexOf(widget.valor)];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _curva = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _overlay?.remove();
    _overlay = null;
    _controller.dispose();
    super.dispose();
  }

  void _alternar() => _overlay == null ? _abrir() : _cerrar();

  void _abrir() {
    _overlay = OverlayEntry(builder: _construirMenu);
    Overlay.of(context).insert(_overlay!);
    _controller.forward();
  }

  Future<void> _cerrar({bool inmediato = false}) async {
    if (_overlay == null) return;
    if (!inmediato) await _controller.reverse();
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() {});
  }

  Widget _construirMenu(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _cerrar,
          ),
        ),
        CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          offset: Offset(0, widget.alto + 6),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizeTransition(
              sizeFactor: _curva,
              axisAlignment: -1,
              child: FadeTransition(
                opacity: _curva,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: widget.ancho,
                    decoration: BoxDecoration(
                      color: widget.colorFondo,
                      borderRadius: BorderRadius.circular(widget.alto / 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < widget.valores.length; i++)
                          _opcion(i),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _opcion(int i) {
    final seleccionado = widget.valores[i] == widget.valor;
    return InkWell(
      borderRadius: BorderRadius.circular(widget.alto / 2),
      onTap: () {
        widget.onChanged(widget.valores[i]);
        _cerrar();
      },
      child: Container(
        height: widget.alto,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          widget.etiquetas[i],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: widget.colorTexto,
            fontSize: 15,
            fontWeight: seleccionado ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final abierto = _overlay != null;
    return CompositedTransformTarget(
      link: _link,
      child: Material(
        color: widget.colorFondo,
        borderRadius: BorderRadius.circular(widget.alto / 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.alto / 2),
          onTap: () {
            _alternar();
            setState(() {});
          },
          child: SizedBox(
            width: widget.ancho,
            height: widget.alto,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      _etiquetaActual,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.colorTexto,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: abierto ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: widget.colorTexto,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
