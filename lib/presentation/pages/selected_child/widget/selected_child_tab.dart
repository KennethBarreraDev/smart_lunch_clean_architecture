import 'package:flutter/material.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class SelectedChildTab extends StatefulWidget {
  final List<Widget> children;

  const SelectedChildTab({
    super.key,
    required this.children,
  }) : assert(children.length == 2, 'Se requieren exactamente 2 widgets para las pestañas.');

  @override
  State<SelectedChildTab> createState() => _SelectedChildTabState();
}

class _SelectedChildTabState extends State<SelectedChildTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            tabs: [
              Tab(text: AppLocalizations.of(context)!.information_text),
              Tab(text: AppLocalizations.of(context)!.student_management),
            ],
          ),
        ),

        const SizedBox(height: 20),
        
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}