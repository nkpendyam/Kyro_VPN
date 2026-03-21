package com.kyrovpn.kyro_vpn

import android.app.Service
import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import android.util.Log

class KyroVpnService : VpnService() {
    private var vpnInterface: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val serverPublicKey = intent?.getStringExtra("serverPublicKey") ?: ""
        val endpoint = intent?.getStringExtra("endpoint") ?: ""
        val localAddress = intent?.getStringExtra("localAddress") ?: "10.0.0.2"
        val dns = intent?.getStringExtra("dns") ?: "1.1.1.1"

        Log.i("KyroVpnService", "Starting VPN to $endpoint with pubkey $serverPublicKey")

        // 1. Establish VPN Interface
        try {
            vpnInterface = Builder()
                .setSession("Kyro VPN")
                .setMtu(1280)
                .addAddress(localAddress, 24)
                .addDnsServer(dns)
                .addRoute("0.0.0.0", 0)
                .addRoute("::", 0)
                .establish()
            
            Log.i("KyroVpnService", "VPN Interface established")
        } catch (e: Exception) {
            Log.e("KyroVpnService", "Failed to establish VPN interface: ${e.message}")
            stopSelf()
        }

        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        vpnInterface?.close()
        vpnInterface = null
        Log.i("KyroVpnService", "VPN Stopped")
    }
}
