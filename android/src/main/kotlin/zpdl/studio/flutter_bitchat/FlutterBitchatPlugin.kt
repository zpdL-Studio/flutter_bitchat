package zpdl.studio.flutter_bitchat

import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.lifecycle.lifecycleScope
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import zpdl.studio.flutter_bitchat.mesh.BluetoothMeshDelegate
import zpdl.studio.flutter_bitchat.mesh.BluetoothMeshService
import zpdl.studio.flutter_bitchat.model.BitchatMessage
import zpdl.studio.flutter_bitchat.model.DeliveryAck
import zpdl.studio.flutter_bitchat.model.DeliveryStatus
import zpdl.studio.flutter_bitchat.model.ReadReceipt
import zpdl.studio.flutter_bitchat.onboarding.PermissionManager
import zpdl.studio.flutter_bitchat.onboarding.PermissionType

/** FlutterBitchatPlugin */
class FlutterBitchatPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    BluetoothMeshDelegate {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var bluetoothMeshDelegateEventChannel: BluetoothMeshDelegateEventChannel

    private var activityPluginBinding: ActivityPluginBinding? = null
    private val flutterRequestPermission: FlutterRequestPermission =
        FlutterRequestPermission("flutter_bitchat_plugin_request_permissions")
    private var permissionManager: PermissionManager? = null

    private var meshService: BluetoothMeshService? = null

    private fun getPermissionManager(): PermissionManager {
        permissionManager = permissionManager ?: PermissionManager(getActivity())
        return permissionManager!!
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_bitchat")
        channel.setMethodCallHandler(this)

        bluetoothMeshDelegateEventChannel = BluetoothMeshDelegateEventChannel(
            flutterPluginBinding.binaryMessenger,
            "flutter_bitchat_bluetooth_mesh_delegate",
            channel
        )
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

                "FlutterBitchat@myPeerID" -> {
                    val meshService = this.meshService
                    if (meshService == null) {
                        throw PluginException.MeshServiceNotFound("Bluetooth mesh service not found")
                    }
                    result.success(meshService.myPeerID)
                }

                "FlutterBitchat@startMeshService" -> {
                    val meshService = this.meshService
                    if (meshService != null) {
                        meshService.delegate = this
                        meshService.startServices()
                        result.success(true)
                    } else {
                        throw PluginException.MeshServiceNotFound("Bluetooth mesh service not found")
                    }
                }

                "FlutterBitchat@stopMeshService" -> {
                    val meshService = this.meshService
                    if (meshService != null) {
                        meshService.stopServices()
                        result.success(true)
                    } else {
                        throw PluginException.MeshServiceNotFound("Bluetooth mesh service not found")
                    }
                }

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            if (e is PluginException) {
                when (e) {
                    is PluginException.ActivityNotFound -> result.error(
                        "activityNotFound",
                        e.message,
                        null
                    )

                    is PluginException.MeshServiceNotFound -> result.error(
                        "meshServiceNotFound",
                        e.message,
                        null
                    )
                }
            } else {
                result.error("unknown", e.message, null)
            }
            return
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        bluetoothMeshDelegateEventChannel.onCancel(null)
    }

    private fun getActivity(): Activity {
        return activityPluginBinding?.activity
            ?: throw PluginException.ActivityNotFound("activity not found")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        flutterRequestPermission.registerPluginBinding(binding)
        meshService = BluetoothMeshService(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityPluginBinding = null
        permissionManager = null
        flutterRequestPermission.deregisterPluginBinding()
        meshService?.stopServices()
        meshService = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        flutterRequestPermission.registerPluginBinding(binding)
        meshService = BluetoothMeshService(binding.activity)
    }

    override fun onDetachedFromActivity() {
        activityPluginBinding = null
        permissionManager = null
        flutterRequestPermission.deregisterPluginBinding()
        meshService?.stopServices()
        meshService = null
    }

    private fun invokeMethod(method: String, arguments: Any? = null) {
        Log.i("FlutterBitchat", "invokeMessage -> method: $method, arguments: $arguments")
        runBlocking(context = Dispatchers.Main) {
            channel.invokeMethod(method, arguments)
        }
    }

    private fun <T> invokeMethodResult(method: String, arguments: Any? = null): T {
        Log.i("FlutterBitchat", "invokeMessageResult -> method: $method, arguments: $arguments")
        return runBlocking(context = Dispatchers.Main) {
            val deferredResult = CompletableDeferred<T>()
            channel.invokeMethod(method, arguments, object : Result {
                override fun success(result: Any?) {
                    Log.i("FlutterBitchat", "$method -> success: $result")
                    @Suppress("UNCHECKED_CAST")
                    deferredResult.complete(result as T)
                }

                override fun error(
                    errorCode: String,
                    errorMessage: String?,
                    errorDetails: Any?
                ) {
                    Log.i(
                        "FlutterBitchat",
                        "$method -> error: $errorCode, errorMessage: $errorMessage, errorDetails: $errorDetails"
                    )
                    deferredResult.completeExceptionally(Exception("$errorCode $errorMessage"))
                }

                override fun notImplemented() {
                    Log.i("FlutterBitchat", "$method -> notImplemented")
                    deferredResult.completeExceptionally(Exception("notImplemented"))
                }
            })

            return@runBlocking deferredResult.await()
        }
    }

    override fun didReceiveMessage(message: BitchatMessage) {
        Log.i("FlutterBitchat", "didReceiveMessage -> message: $message")
        val peerID = message.senderPeerID
        val rssi = peerID?.let { peerID ->
            val meshService = this.meshService
            if(meshService != null) {
                val result = meshService.getPeerRSSI()[peerID]
                Log.i("FlutterBitchat", "didReceiveMessage -> rssi: $result")
                return@let result
            }
            return@let null
        }

        val json = mutableMapOf<Any, Any?>().apply {
            for (e in message.toJson()) {
                put(e.key, e.value)
            }
            put("senderRSSI", rssi ?: -60)
        }

        invokeMethod("FlutterBitchat@didReceiveMessage", json)
    }

    override fun didConnectToPeer(peerID: String) {
        Log.i("FlutterBitchat", "didConnectToPeer -> peerID: $peerID")

        invokeMethod(
            "FlutterBitchat@didConnectToPeer", arguments = mapOf(
                "peerID" to peerID
            )
        )
    }

    override fun didDisconnectFromPeer(peerID: String) {
        Log.i("FlutterBitchat", "didDisconnectFromPeer -> peerID: $peerID")
    }

    override fun didUpdatePeerList(peers: List<String>) {
        Log.i("FlutterBitchat", "didUpdatePeerList -> peers: $peers")
        invokeMethod("FlutterBitchat@didUpdatePeerList", peers)
    }

    override fun didReceiveChannelLeave(channel: String, fromPeer: String) {
        Log.i("FlutterBitchat", "didReceiveChannelLeave -> channel: $channel, fromPeer: $fromPeer")
    }

    override fun didReceiveDeliveryAck(ack: DeliveryAck) {
        Log.i("FlutterBitchat", "didReceiveDeliveryAck -> ack: $ack")
    }

    override fun didReceiveReadReceipt(receipt: ReadReceipt) {
        Log.i("FlutterBitchat", "didReceiveReadReceipt -> receipt: $receipt")
    }

    override fun decryptChannelMessage(
        encryptedContent: ByteArray,
        channel: String
    ): String? {
        Log.i(
            "FlutterBitchat",
            "decryptChannelMessage -> encryptedContent: $encryptedContent, channel: channel"
        )
        return null
    }

    override fun getNickname(): String? {
        return invokeMethodResult("FlutterBitchat@getNickname", null)
    }

    override fun isFavorite(peerID: String): Boolean {
        Log.i("FlutterBitchat", "isFavorite -> peerID:$peerID")
        return true
    }

    override fun registerPeerPublicKey(peerID: String, publicKeyData: ByteArray) {
        Log.i(
            "FlutterBitchat",
            "registerPeerPublicKey -> peerID: $peerID, publicKeyData: $publicKeyData"
        )
        val md = java.security.MessageDigest.getInstance("SHA-256")
        val hash = md.digest(publicKeyData)
        val fingerprint = hash.take(8).joinToString("") { "%02x".format(it) }
        invokeMethod(
            "FlutterBitchat@registerPeerPublicKey", mapOf(
                "peerID" to peerID,
                "fingerprint" to fingerprint,
            )
        )
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

fun BitchatMessage.toJson(): MutableMap<Any, *> {
    return mutableMapOf(
        "id" to id,
        "sender" to sender,
        "content" to content,
        "timestamp" to timestamp.time,
        "isRelay" to isRelay,
        "originalSender" to originalSender,
        "isPrivate" to isPrivate,
        "recipientNickname" to recipientNickname,
        "senderPeerID" to senderPeerID,
        "mentions" to mentions,
        "channel" to channel,
        "encryptedContent" to encryptedContent,
        "isEncrypted" to isEncrypted,
        "deliveryStatus" to deliveryStatus?.toJson(),
    )
}

fun DeliveryStatus.toJson(): Map<*, *> {
    return when (this) {
        DeliveryStatus.Sending ->
            mapOf("type" to "Sending")

        DeliveryStatus.Sent -> mapOf("type" to "Sent")
        is DeliveryStatus.Delivered ->
            mapOf("type" to "Delivered", "to" to to, "at" to at.time)

        is DeliveryStatus.Read -> mapOf("type" to "Read", "by" to by, "at" to at.time)
        is DeliveryStatus.Failed -> mapOf("type" to "Failed", "reason" to reason)
        is DeliveryStatus.PartiallyDelivered -> mapOf(
            "type" to "PartiallyDelivered",
            "reached" to reached,
            "total" to total
        )
    }
}

