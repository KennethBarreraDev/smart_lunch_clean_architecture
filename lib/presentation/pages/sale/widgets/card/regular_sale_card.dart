import 'package:flutter/material.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class RegularSaleCard extends StatelessWidget {
  const RegularSaleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.deliver_to,
          style: const TextStyle(
            color: Colors.black26,
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            fontFamily: "Comfortaa",
          ),
        ),
      ],
    );
  }
}
