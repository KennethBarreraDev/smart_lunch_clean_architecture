import 'dart:developer' as developer;

import 'package:flutter/services.dart';

const _sandboxUrl = "https://sandbox-api.openpay.mx";
const _productionUrl = "https://api.openpay.mx";

class Openpay {
  static MethodChannel openpayPlatform = const MethodChannel("smart.lunch/openpay");

  /// enable sandox or production mode
  /// False by default
  final bool isProductionMode;

  /// Your merchant id
  final String merchantId;

  /// Your public API Key
  final String apiKey;

  final String deviceSessionId;

  Openpay(
    this.merchantId,
    this.apiKey,
    this.deviceSessionId, {
    this.isProductionMode = false,
  });

  Future<void> initializeOpenpay() async {
    try {
      await Openpay.openpayPlatform.invokeMethod('initialize', {
        'merchantId': merchantId,
        'publicApiKey': apiKey,
        'isProductionMode': isProductionMode,
      });
      developer.log("Openpay initialized", name: "openpay_provider");
      
    } catch (e) {
      developer.log("Error initializing openpay: $e", name: "openpay_provider");
    }
  }

  
}
