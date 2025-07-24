package zpdl.studio.flutter_bitchat

sealed class PluginException(message: String): Exception(message) {
    data class ActivityNotFound(override val message: String): PluginException(message)
}


//class PluginNfcTimeoutException(message: String) :
//    PluginException(PluginExceptionCode.NfcTimeOut, message)