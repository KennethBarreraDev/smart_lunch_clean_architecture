import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:smart_lunch/data/models/cafeteria_model.dart';
import 'package:smart_lunch/l10n/app_localizations.dart';

class SupportComponent extends StatelessWidget {
  SupportComponent({super.key, this.cafeteria});

  Cafeteria? cafeteria;

  @override
  Widget build(BuildContext context) {
    return (cafeteria?.email ?? "").isNotEmpty ||
            (cafeteria?.phone ?? "").isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.1)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: AssetImage(AppImages.supportImage),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.need_help_question,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              (cafeteria?.phone ?? '').isNotEmpty
                                  ? Row(
                                      children: [
                                        const Icon(Icons.phone, size: 17),
                                        const SizedBox(width: 5),
                                        Text(
                                          (cafeteria?.phone ?? ''),
                                          style: const TextStyle(
                                            fontFamily: 'Comfortaa',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              const SizedBox(width: 10),
                              (cafeteria?.email ?? '').isNotEmpty
                                  ? Row(
                                      children: [
                                        const Icon(Icons.mail, size: 17),
                                        const SizedBox(width: 5),
                                        Text(
                                          (cafeteria?.email ?? ''),
                                          style: const TextStyle(
                                            fontFamily: 'Comfortaa',
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
