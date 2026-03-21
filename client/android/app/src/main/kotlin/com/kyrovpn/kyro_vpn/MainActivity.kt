package com.kyrovpn.kyro_vpn

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.kyrovpn/vpn"
    private var vpnStatus = "disconnected"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "startVpn" -> {
                    val serverPublicKey = call.argument<String>("serverPublicKey")
                    val endpoint = call.argument<String>("endpoint")
                    val localAddress = call.argument<String>("localAddress")
                    val dns = call.argument<String>("dns")

                    val intent = VpnService.prepare(this)
                    if (intent != null) {
                        startActivityForResult(intent, 0)
                        result.success(false) // Needs permission first
                    } else {
                        onActivityResult(0, Activity.RESULT_OK, null)
                        
                        val vpnIntent = Intent(this, KyroVpnService::class.java).apply {
                            putExtra("serverPublicKey", serverPublicKey)
                            putExtra("endpoint", endpoint)
                            putExtra("localAddress", localAddress)
                            putExtra("dns", dns)
                        }
                        startService(vpnIntent)
                        vpnStatus = "connected"
                        result.success(true)
                    }
                }
                "stopVpn" -> {
                    stopService(Intent(this, KyroVpnService::class.java))
                    vpnStatus = "disconnected"
                    result.success(null)
                }
                "getStatus" -> {
                    result.success(vpnStatus)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
