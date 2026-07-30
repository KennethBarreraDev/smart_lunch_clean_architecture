import 'package:flutter/material.dart';

class ReusableTabSubtitle extends StatelessWidget {
  const ReusableTabSubtitle({
    super.key,
    this.subtitle ="Menu",
    required this.tabNames,
    required this.tabViews,
    this.showButton = false,
    this.buttonText = 'Guardar',
    this.onButtonPressed,
    this.selectedTextColor = Colors.black,
    this.unselectedTextColor = Colors.grey,
    this.indicatorColor = const Color(0xFFFFA36A),
    this.titleStyle,
    this.button,
  }) : assert(
         tabNames.length == tabViews.length,
         'La cantidad de nombres debe coincidir con la cantidad de widgets',
       );

  final String? subtitle;
  final TextStyle? titleStyle;

  /// pestañas
  final List<String> tabNames;
  final List<Widget> tabViews;

  /// boton
  final bool showButton;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? button;

  /// Colores
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color indicatorColor;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabNames.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Text(
                    subtitle!,
                    style:
                        titleStyle ??
                        const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFA36A),
                        ),
                  ),
                ),
              Expanded(
                child: TabBar(
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  indicatorColor: indicatorColor,
                  indicatorWeight: 3,
                  labelColor: selectedTextColor,
                  unselectedLabelColor: unselectedTextColor,
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: tabNames.map((name) => Tab(text: name)).toList(),
                ),
              ),
            ],
          ),

          Expanded(child: TabBarView(children: tabViews)),

          if (showButton)
            Padding(
              padding: const EdgeInsets.all(16),
              child:
                  button ??
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      child: Text(buttonText),
                    ),
                  ),
            ),
        ],
      ),
    );
  }
}
