package com.ideapp.smart.lunch.smart_lunch

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import mx.openpay.android.Openpay

class MainActivity: FlutterActivity() {

    private val _channel = "smart.lunch/openpay"
    private var _openPay: Openpay? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, _channel)
            .setMethodCallHandler { call, result ->

                when (call.method) {

                    "initialize" -> {
                        val args = call.arguments as Map<String, Any>

                        val merchantId = args["merchantId"] as String
                        val publicApiKey = args["publicApiKey"] as String
                        val isProductionMode = args["isProductionMode"] as Boolean

                        initializeOpenPay(merchantId, publicApiKey, isProductionMode)
                        result.success(200)
                    }

                    "getDeviceSessionId" -> {
                        result.success(getDeviceSessionId())
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun initializeOpenPay(
        merchantId: String,
        apiKey: String,
        isProductionMode: Boolean
    ) {
        _openPay = Openpay(merchantId, apiKey, isProductionMode)
    }

    private fun getDeviceSessionId(): String {
        return _openPay?.deviceCollectorDefaultImpl?.setup(this) ?: ""
    }
}