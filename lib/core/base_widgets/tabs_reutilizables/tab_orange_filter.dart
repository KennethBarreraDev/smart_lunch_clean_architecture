import 'package:flutter/material.dart';

class TabOrangeFilter extends StatefulWidget {
  const TabOrangeFilter({
    super.key,
    required this.tabs,
    required this.views,
    this.initialIndex = 0,
    this.onTabChanged,
    this.onFilterTap,
    this.selectedColor = const Color(0xFFF5836B),
    this.backgroundColor = Colors.white,
  }) : assert(tabs.length == views.length,
            'tabs y views deben tener la misma longitud');

  /// Etiquetas de cada pestaña.
  final List<String> tabs;

  /// Contenido asociado a cada pestaña (se muestra en el TabBarView).
  final List<Widget> views;

  final int initialIndex;

  /// Se dispara cada vez que cambia la pestaña activa.
  final ValueChanged<int>? onTabChanged;

  /// Si es distinto de null, se muestra un ícono de filtro a la derecha.
  final VoidCallback? onFilterTap;

  final Color selectedColor;
  final Color backgroundColor;

  @override
  State<TabOrangeFilter> createState() => _TabOrangeFilterState();
}

class _TabOrangeFilterState extends State<TabOrangeFilter>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _controller.addListener(() {
      if (!_controller.indexIsChanging) {
        widget.onTabChanged?.call(_controller.index);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: widget.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _controller,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  // Quita la línea inferior y el divisor por defecto.
                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.symmetric(vertical: 4),
                  indicator: BoxDecoration(
                    color: widget.selectedColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: widget.selectedColor,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  overlayColor:
                      WidgetStateProperty.all(Colors.transparent),
                  splashFactory: NoSplash.splashFactory,
                  tabs: [
                    for (final t in widget.tabs)
                      Tab(
                        height: 44,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(t),
                        ),
                      ),
                  ],
                ),
              ),
              if (widget.onFilterTap != null)
                IconButton(
                  onPressed: widget.onFilterTap,
                  icon: Icon(Icons.tune_rounded, color: widget.selectedColor),
                  tooltip: 'Filtrar',
                ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.views,
          ),
        ),
      ],
    );
  }
}