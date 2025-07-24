package zpdl.studio.flutter_bitchat.onboarding

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts

/**
 * Manages Bluetooth enable/disable state and user prompts
 * Checks Bluetooth status on every app startup
 */
class BluetoothStatusManager(
    private val activity: ComponentActivity,
    private val context: Context,
    private val onBluetoothEnabled: () -> Unit,
    private val onBluetoothDisabled: (String) -> Unit
) {

    companion object {
        private const val TAG = "BluetoothStatusManager"
    }

    private var bluetoothEnableLauncher: ActivityResultLauncher<Intent>? = null
    private var bluetoothAdapter: BluetoothAdapter? = null

    init {
        setupBluetoothAdapter()
        setupBluetoothEnableLauncher()
    }

    /**
     * Setup Bluetooth adapter reference
     */
    private fun setupBluetoothAdapter() {
        try {
            val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
            bluetoothAdapter = bluetoothManager.adapter
            Log.d(TAG, "Bluetooth adapter initialized: ${bluetoothAdapter != null}")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize Bluetooth adapter", e)
            bluetoothAdapter = null
        }
    }

    /**
     * Setup launcher for Bluetooth enable request
     */
    private fun setupBluetoothEnableLauncher() {
        bluetoothEnableLauncher = activity.registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->
            val isEnabled = bluetoothAdapter?.isEnabled == true
            Log.d(TAG, "Bluetooth enable request result: $isEnabled (result code: ${result.resultCode})")
            if (isEnabled) {
                onBluetoothEnabled()
            } else {
                onBluetoothDisabled("Bluetooth is required for bitchat to discover and connect to nearby users. Please enable Bluetooth to continue.")
            }
        }
    }

    /**
     * Check if Bluetooth is supported on this device
     */
    fun isBluetoothSupported(): Boolean {
        return bluetoothAdapter != null
    }

    /**
     * Check if Bluetooth is currently enabled (permission-safe)
     */
    fun isBluetoothEnabled(): Boolean {
        return try {
            bluetoothAdapter?.isEnabled == true
        } catch (securityException: SecurityException) {
            // If we can't check due to permissions, assume disabled
            Log.w(TAG, "Cannot check Bluetooth enabled state due to missing permissions")
            false
        } catch (e: Exception) {
            Log.w(TAG, "Error checking Bluetooth enabled state: ${e.message}")
            false
        }
    }

    /**
     * Check Bluetooth status and handle accordingly (permission-safe)
     * This should be called on every app startup
     */
    fun checkBluetoothStatus(): BluetoothStatus {
        // Log.d(TAG, "Checking Bluetooth status")
        
        return when {
            bluetoothAdapter == null -> {
                Log.e(TAG, "Bluetooth not supported on this device")
                BluetoothStatus.NOT_SUPPORTED
            }
            !isBluetoothEnabled() -> {
                Log.w(TAG, "Bluetooth is disabled or cannot be checked")
                BluetoothStatus.DISABLED
            }
            else -> {
                // Log.d(TAG, "Bluetooth is enabled and ready")
                BluetoothStatus.ENABLED
            }
        }
    }

    /**
     * Request user to enable Bluetooth (permission-aware)
     */
    fun requestEnableBluetooth() {
        Log.d(TAG, "Requesting user to enable Bluetooth")
        
        try {
            val enableBluetoothIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            bluetoothEnableLauncher?.launch(enableBluetoothIntent)
        } catch (securityException: SecurityException) {
            // Permission not granted yet - this is expected during onboarding
            Log.w(TAG, "Cannot request Bluetooth enable due to missing BLUETOOTH_CONNECT permission")
            onBluetoothDisabled("Bluetooth permissions are required before enabling Bluetooth. Please grant permissions first.")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to request Bluetooth enable", e)
            onBluetoothDisabled("Failed to request Bluetooth enable: ${e.message}")
        }
    }

    /**
     * Handle Bluetooth status check result
     */
    fun handleBluetoothStatus(status: BluetoothStatus) {
        when (status) {
            BluetoothStatus.ENABLED -> {
                Log.d(TAG, "Bluetooth is enabled, proceeding")
                onBluetoothEnabled()
            }
            BluetoothStatus.DISABLED -> {
                Log.d(TAG, "Bluetooth is disabled, requesting enable")
                requestEnableBluetooth()
            }
            BluetoothStatus.NOT_SUPPORTED -> {
                Log.e(TAG, "Bluetooth not supported")
                onBluetoothDisabled("This device doesn't support Bluetooth, which is required for bitchat to function.")
            }
        }
    }

    /**
     * Get user-friendly status message
     */
    fun getStatusMessage(status: BluetoothStatus): String {
        return when (status) {
            BluetoothStatus.ENABLED -> "Bluetooth is enabled and ready"
            BluetoothStatus.DISABLED -> "Bluetooth is disabled. Please enable Bluetooth to use bitchat."
            BluetoothStatus.NOT_SUPPORTED -> "This device doesn't support Bluetooth."
        }
    }

    /**
     * Get detailed diagnostics (permission-safe)
     */
    fun getDiagnostics(): String {
        return buildString {
            appendLine("Bluetooth Status Diagnostics:")
            appendLine("Adapter available: ${bluetoothAdapter != null}")
            appendLine("Bluetooth supported: ${isBluetoothSupported()}")
            appendLine("Bluetooth enabled: ${isBluetoothEnabled()}")
            appendLine("Current status: ${checkBluetoothStatus()}")
            
            // Only access adapter details if we have permission and adapter is available
            bluetoothAdapter?.let { adapter ->
                try {
                    // These calls require BLUETOOTH_CONNECT permission on Android 12+
                    appendLine("Adapter name: ${adapter.name ?: "Unknown"}")
                    appendLine("Adapter address: ${adapter.address ?: "Unknown"}")
                } catch (securityException: SecurityException) {
                    // Permission not granted yet, skip detailed info
                    appendLine("Adapter details: [Permission required]")
                } catch (e: Exception) {
                    appendLine("Adapter details: [Error: ${e.message}]")
                }
                appendLine("Adapter state: ${getAdapterStateName(adapter.state)}")
            }
        }
    }

    private fun getAdapterStateName(state: Int): String {
        return when (state) {
            BluetoothAdapter.STATE_OFF -> "OFF"
            BluetoothAdapter.STATE_TURNING_ON -> "TURNING_ON"
            BluetoothAdapter.STATE_ON -> "ON"
            BluetoothAdapter.STATE_TURNING_OFF -> "TURNING_OFF"
            else -> "UNKNOWN($state)"
        }
    }

    /**
     * Log current Bluetooth status for debugging
     */
    fun logBluetoothStatus() {
        Log.d(TAG, getDiagnostics())
    }
}

/**
 * Bluetooth status enum
 */
enum class BluetoothStatus {
    ENABLED,
    DISABLED, 
    NOT_SUPPORTED
}
