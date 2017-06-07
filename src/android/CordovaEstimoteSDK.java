package no.apility;

import android.util.Log;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CordovaArgs;

public class CordovaEstimoteSDK extends CordovaPlugin
{

    /**
	 * Plugin initializer.
	 */
	@Override
    public void pluginInitialize() {
        super.pluginInitialize();
        Log.i(LOGTAG, "pluginInitialize");
    }

	/**
	 * Plugin reset.
	 * Called when the WebView does a top-level navigation or refreshes.
	 */
	@Override
	public void onReset() {
        super.onReset();
		Log.i(LOGTAG, "onReset");
	}

	/**
	 * The final call you receive before your activity is destroyed.
	 */
	@Override
	public void onDestroy() {
        super.onDestroy();
		Log.i(LOGTAG, "onDestroy");
	}

    /**
	 * Entry point for JavaScript calls.
	 */
	@Override
	public boolean execute(String action, CordovaArgs args, final CallbackContext callbackContext) throws JSONException {
        Log.i(LOGTAG, "execute " + action);
        boolean response = true;

        switch(action) {
            default:
                break;
        }

		return res;
	}

}