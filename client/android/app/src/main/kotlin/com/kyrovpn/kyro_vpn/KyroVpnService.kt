package com.kyrovpn.kyro_vpn

import android.app.Service
import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import android.util.Log
import java.io.File

class KyroVpnService : VpnService() {
    private var vpnInterface: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val configPath = intent?.getStringExtra("configPath") ?: ""

        if (configPath.isEmpty()) {
            Log.e("KyroVpnService", "Config path is empty")
            stopSelf()
            return START_NOT_STICKY
        }

        Log.i("KyroVpnService", "Starting VPN with config from $configPath")

        try {
            val configFile = File(configPath)
            if (configFile.exists()) {
                // In a full implementation, we would pass this file to the amneziawg-go JNI binding.
                // For this stub, we parse the basic IP/DNS to establish the Android VpnService interface.
                val configContent = configFile.readText()
                
                // Extremely naive parsing for the stub
                val addressMatch = Regex("Address\\s*=\\s*([^\\s]+)").find(configContent)
                val dnsMatch = Regex("DNS\\s*=\\s*([^\\s,]+)").find(configContent)
                
                val localAddress = addressMatch?.groupValues?.get(1)?.split("/")?.get(0) ?: "10.0.0.2"
                val dns = dnsMatch?.groupValues?.get(1) ?: "1.1.1.1"

                vpnInterface = Builder()
                    .setSession("Kyro VPN")
                    .setMtu(1280)
                    .addAddress(localAddress, 24)
                    .addDnsServer(dns)
                    .addRoute("0.0.0.0", 0)
                    .addRoute("::", 0) // Prevents IPv6 leaks
                    .establish()
                
                Log.i("KyroVpnService", "VPN Interface established securely")
                
                // Security: Wipe the config file from disk immediately
                configFile.delete()
            } else {
                Log.e("KyroVpnService", "Config file not found")
                stopSelf()
            }
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
