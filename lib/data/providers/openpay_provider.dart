import 'dart:developer' as developer;

import 'package:flutter/services.dart';

const _sandboxUrl = "https://sandbox-api.openpay.mx";
const _productionUrl = "https://api.openpay.mx";

class Openpay {
  MethodChannel openpayPlatform = const MethodChannel("smart.lunch/openpay");

  /// enable sandox or production mode
  /// False by default
  final bool isProductionMode;

  /// Your merchant id
  final String merchantId;

  /// Your public API Key
  final String apiKey;

  Openpay(this.merchantId, this.apiKey, {this.isProductionMode = false});

  String get _merchantBaseUrl => '$baseUrl/v1/$merchantId';

  String get baseUrl => isProductionMode ? _productionUrl : _sandboxUrl;

  Future<void> initializeOpenpay() async {
    try {
      await openpayPlatform.invokeMethod('initialize', {
        'merchantId': merchantId,
        'publicApiKey': apiKey,
        'isProductionMode': isProductionMode,
      });
    } catch (e) {
      developer.log("Error initializing openpay: $e", name: "openpay_provider");
    }
  }
}
