package zpdl.studio.flutter_bitchat

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.edit
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry

class FlutterRequestPermission(private val prefName: String) : PluginRegistry.RequestPermissionsResultListener {

    companion object {
        const val PERMISSION_CODE = 1001
    }

    enum class PermissionStatus(val value: String) {
        NotDetermined("notDetermined"),
        Denied("denied"),
        Granted("authorizedAlways");
    }

    var pluginBinding: ActivityPluginBinding? = null
        private set

    private var requestPermissionParam: Pair<Int, (PermissionStatus) -> Unit>? = null
    private var permissionCode = PERMISSION_CODE

    private fun nextPermissionCode(): Int {
        return permissionCode++
    }

    fun registerPluginBinding(binding: ActivityPluginBinding) {
        deregisterPluginBinding()
        binding.addRequestPermissionsResultListener(this)
        pluginBinding = binding
    }

    fun deregisterPluginBinding() {
        pluginBinding?.removeRequestPermissionsResultListener(this)
        pluginBinding = null
    }

    fun checkScanPermission(permissions: List<String>): PermissionStatus? {
        val activity = pluginBinding?.activity ?: return null

        return checkScanPermission(activity, permissions)
    }

    fun checkScanPermission(activity: Activity, permissions: List<String>): PermissionStatus {
        var permissionStatus = PermissionStatus.Granted
        for (permission in permissions) {
            when (checkScanPermission(activity, permission)) {
                PermissionStatus.NotDetermined -> {
                    permissionStatus = PermissionStatus.NotDetermined
                }

                PermissionStatus.Denied -> {
                    return PermissionStatus.Denied
                }

                PermissionStatus.Granted -> {}
            }
        }
        return permissionStatus
    }

    private fun checkScanPermission(activity: Activity, name: String): PermissionStatus {
        return if (isPermissionGranted(
                activity,
                name)
        ) {
            PermissionStatus.Granted
        } else if (!wasPermissionDeniedBefore(
                activity,
                name
            ) || ActivityCompat.shouldShowRequestPermissionRationale(activity, name)
        ) {
            PermissionStatus.NotDetermined
        } else {
            PermissionStatus.Denied
        }
    }

    fun isPermissionGranted(context: Context, permission: String): Boolean {
        return ContextCompat.checkSelfPermission(
            context,
            permission
        ) == PackageManager.PERMISSION_GRANTED
    }

    private fun wasPermissionDeniedBefore(context: Context, permissionName: String): Boolean {
        val sharedPreferences = context.getSharedPreferences(prefName, Context.MODE_PRIVATE)
        return sharedPreferences.getBoolean(
            permissionName,
            false
        )
    }

    private fun setWasPermissionDeniedBefore(context: Context, permissionName: String) {
        val sharedPreferences = context.getSharedPreferences(prefName, Context.MODE_PRIVATE)
        sharedPreferences.edit {
            putBoolean(permissionName, true)
        }
    }

    fun getMissingPermissions(context: Context, permissions: List<String>): List<String> {
        return permissions.filter { !isPermissionGranted(context, it) }
    }

    fun requestPermissions(permissions: List<String>, callback: (PermissionStatus) -> Unit) {
        val activity = pluginBinding?.activity
        if (activity == null) {
            callback(PermissionStatus.Denied)
            return
        }

        val missingPermission = getMissingPermissions(activity, permissions)
        if(missingPermission.isEmpty()) {
            callback(PermissionStatus.Granted)
            return
        }

        val requestPermissionParam = Pair(nextPermissionCode(), callback)
        this.requestPermissionParam = requestPermissionParam
        ActivityCompat.requestPermissions(
            activity,
            missingPermission.toTypedArray(),
            requestPermissionParam.first
        )
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        requestPermissionParam?.let {
            if (requestCode == it.first) {
                onRequestPermissionsResult(
                    permissions, grantResults, it.second
                )
                return true
            }
        }
        return false
    }

    private fun onRequestPermissionsResult(
        permissions: Array<out String>,
        grantResults: IntArray,
        callback: (PermissionStatus) -> Unit
    ) {
        val activity = pluginBinding?.activity
        var denied = false
        for (i in permissions.indices) {
            activity?.let {
                setWasPermissionDeniedBefore(it, permissions[i])
            }

            if (grantResults[i] != PackageManager.PERMISSION_GRANTED) {
                denied = true
            }
        }

        callback(if (!denied) PermissionStatus.Granted else PermissionStatus.Denied)
    }
}
