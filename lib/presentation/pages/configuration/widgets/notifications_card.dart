import 'package:flutter/material.dart';
import 'package:smart_lunch/core/base_widgets/checkbox/custom_checkbox.dart';
import 'package:smart_lunch/presentation/pages/configuration/widgets/settings_option_card.dart';

class NotificationsCard extends StatefulWidget {
  const NotificationsCard({super.key});

  @override
  State<NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {
  bool _receiveNotifications = true;

  @override
  Widget build(BuildContext context) {
    return SettingsOptionCard(
      icon: Icons.notifications_none_rounded,
      text: "Recibir notificaciones",
      trailing: CustomCheckbox(
        value: _receiveNotifications,
        text: "",
        onTap: () {
          setState(() {
            _receiveNotifications = !_receiveNotifications;
          });
        },
      ),
    );
  }
}
