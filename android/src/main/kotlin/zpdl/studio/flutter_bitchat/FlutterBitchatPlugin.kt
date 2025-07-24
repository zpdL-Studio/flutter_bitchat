package zpdl.studio.flutter_bitchat

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import zpdl.studio.flutter_bitchat.onboarding.PermissionManager
import zpdl.studio.flutter_bitchat.onboarding.PermissionType

/** FlutterBitchatPlugin */
class FlutterBitchatPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activityPluginBinding: ActivityPluginBinding? = null
    private val flutterRequestPermission: FlutterRequestPermission = FlutterRequestPermission("flutter_bitchat_plugin_request_permissions")
    private var permissionManager: PermissionManager? = null

    private fun getPermissionManager(): PermissionManager {
        permissionManager = permissionManager ?: PermissionManager(getActivity())
        return permissionManager!!
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_bitchat")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "FlutterBitchat@getPlatformVersion" -> {
                    result.success("Android ${android.os.Build.VERSION.RELEASE}")
                }

                "FlutterBitchat@getPermissionStatus" -> {
                    val status = PermissionStatus.fromPermissionManager(getPermissionManager())
                    result.success(
                        mapOf(
                            "hasBluetoothPermission" to status.bluetoothPermission,
                            "hasLocationPermission" to status.notificationPermission,
                            "hasNotificationPermission" to status.notificationPermission,
                        )
                    )
                }
                "FlutterBitchat@requestPermission" -> {
                    val permissionManager = getPermissionManager()
                    flutterRequestPermission.requestPermissions(permissionManager.getRequiredPermissions()) {
                        result.success(it == FlutterRequestPermission.PermissionStatus.Granted)
                    }
                }
            }
        } catch (e: Exception) {
            if (e is PluginException) {
                when (e) {
                    is PluginException.ActivityNotFound -> result.error(
                        "activityNotFound",
                        e.message,
                        null
                    )
                }
            } else {
                result.error("unknown", e.message, null)
            }
            return
        }
        result.notImplemented()

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getActivity(): Activity {
        return activityPluginBinding?.activity
            ?: throw PluginException.ActivityNotFound("activity not found")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        flutterRequestPermission.registerPluginBinding(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityPluginBinding = null
        permissionManager = null
        flutterRequestPermission.deregisterPluginBinding()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        flutterRequestPermission.registerPluginBinding(binding)
    }

    override fun onDetachedFromActivity() {
        activityPluginBinding = null
        permissionManager = null
        flutterRequestPermission.deregisterPluginBinding()
    }
}

private data class PermissionStatus(
    val bluetoothPermission: Boolean,
    val locationPermission: Boolean,
    val notificationPermission: Boolean
) {
    companion object {
        fun fromPermissionManager(permissionManager: PermissionManager): PermissionStatus {
            var bluetoothPermission = true
            var locationPermission = true
            var notificationPermission = true

            permissionManager.getCategorizedPermissions().forEach {
                when (it.type) {
                    PermissionType.NEARBY_DEVICES -> {
                        bluetoothPermission = it.isGranted
                    }

                    PermissionType.PRECISE_LOCATION -> {
                        locationPermission = it.isGranted
                    }

                    PermissionType.NOTIFICATIONS -> {
                        notificationPermission = it.isGranted
                    }

                    PermissionType.OTHER -> {}
                }
            }

            return PermissionStatus(
                bluetoothPermission = bluetoothPermission,
                locationPermission = locationPermission,
                notificationPermission = notificationPermission
            )
        }
    }
}


