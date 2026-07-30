import 'package:flutter/material.dart';

// Los nombres y los widgets deben mantener el mismo orden

class ReusableTabSimple extends StatefulWidget {
  final List<String> tabNames;
  final List<Widget> tabChildren;

  const ReusableTabSimple({
    super.key,
    required this.tabNames,
    required this.tabChildren,
  }) : assert(
         tabNames.length == tabChildren.length,
         'La cantidad de nombres de pestañas debe coincidir con la cantidad de widgets.',
       ),
       assert(tabNames.length >= 2, 'Se requieren al menos 2 pestañas.');

  @override
  State<ReusableTabSimple> createState() => _ReusableTabSimpleState();
}

class _ReusableTabSimpleState extends State<ReusableTabSimple>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabNames.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 260,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFFA6E59),
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: const Color(0xFFFA6E59),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 3.0,
            dividerColor: Colors.transparent,
            tabs: widget.tabNames.map((name) => Tab(text: name)).toList(),
          ),
        ),

        const SizedBox(height: 20),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabChildren,
          ),
        ),
      ],
    );
  }
}
