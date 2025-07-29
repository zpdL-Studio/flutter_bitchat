package zpdl.studio.flutter_bitchat

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/** FlutterBitchatBluetoothMeshDelegateEventChannel */
class BluetoothMeshDelegateEventChannel(
    binaryMessenger: BinaryMessenger,
    name: String,
    private val methodChannel: MethodChannel
) : EventChannel.StreamHandler {
    val eventChannel: EventChannel = EventChannel(binaryMessenger, name)
    var eventSink: EventChannel.EventSink? = null

    init {
        eventChannel.setStreamHandler(this)
    }

    override fun onListen(
        arguments: Any?,
        events: EventChannel.EventSink?
    ) {
        if (events != null) {
            eventSink = events
            events.success(arguments)
        }
    }

    override fun onCancel(arguments: Any?) {
        eventChannel.setStreamHandler(null)
        eventSink = null
    }
}




