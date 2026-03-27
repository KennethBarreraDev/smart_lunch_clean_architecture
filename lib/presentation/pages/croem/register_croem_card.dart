import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_lunch/blocs/croem/croem_bloc.dart';
import 'package:smart_lunch/blocs/croem/croem_event.dart';
import 'package:smart_lunch/blocs/croem/croem_state.dart';
import 'package:smart_lunch/blocs/session/session_bloc.dart';
import 'package:smart_lunch/blocs/session/session_state.dart';
import 'package:smart_lunch/core/base_widgets/appbar/custom_appbar.dart';
import 'package:smart_lunch/core/base_widgets/scaffold/transparent_scaffold.dart';
import 'package:smart_lunch/core/base_widgets/snackbar/generic_snackbar.dart';
import 'package:smart_lunch/core/utils/app_images.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RegisterCroemCardPage extends StatefulWidget {
  const RegisterCroemCardPage({super.key});

  @override
  State<RegisterCroemCardPage> createState() => _RegisterCroemCardPageState();
}

class _RegisterCroemCardPageState extends State<RegisterCroemCardPage> {
  late final WebViewController croemController;

  @override
  void initState() {
    super.initState();

    croemController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (message) {
          final contextLocal = context;

          final sessionState = contextLocal.read<SessionBloc>().state;
          final croemState = contextLocal.read<CroemBloc>().state;

          final Map<String, dynamic> response = jsonDecode(message.message);

          contextLocal.read<CroemBloc>().add(RegisterCroemCardEvent());

          developer.log("Response is $response", name: "card_response");
          if (response["ResponseCode"] == "T00" &&
              sessionState is SessionAuthenticated &&
              croemState is CroemCardsLoaded) {
            contextLocal.read<CroemBloc>().add(
              RegisterCroemCardEvent(
                tokenizedCard: response["TokenDetails"]["AccountToken"],
                userID: sessionState.sessionData?.userId ?? "",
                cardNumber: response["TokenDetails"]["CardNumber"],
                cardHolderName: response["TokenDetails"]["CardHolderName"],
                identifierName: "Test",
                cards: croemState.cards,
              ),
            );
          }
        },
      )
      ..loadFlutterAsset("assets/web/index.html");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CroemBloc, CroemState>(
      listener: (context, state) {
        if (state is CroemError) {
          showCustomSnackBar(
            context: context,
            bannerType: BannerTypes.errorBanner.type,
            bannerMessage: state.message,
          );
        }
      },
      child: TransparentScaffold(
        selectedOption: "Promociones",
        body: Column(
          children: [
            CustomAppBar(
              height: 140,
              showPageTitle: true,
              pageTitle: "Nueva tarjeta",
              titleAlignment: Alignment.bottomRight,
              image: AppImages.appBarShortImg,
              showDrawer: false,
              titleSize: 24,
            ),
            Container(color: Colors.white, height: 30),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: WebViewWidget(controller: croemController),
                    ),
                    Expanded(
                      flex: 2,
                      child: Image.asset(AppImages.croemSupport),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
