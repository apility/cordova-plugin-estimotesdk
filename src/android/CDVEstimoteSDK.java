package no.apility;

import android.util.Log;
import android.app.Application;
import android.content.Context;

import com.estimote.sdk.SystemRequirementsChecker;

import org.apache.cordova.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class CDVEstimoteSDK extends CordovaPlugin
{

	private static final String tag = "CDVEstimoteSDK";

    /**
	 * Plugin initializer.
	 */
	@Override
    public void pluginInitialize() {
        super.pluginInitialize();
        Log.i(tag, "pluginInitialize");
    }

	public void requestPermissions(CallbackContext callbackContext) {
		Log.i(tag, "requestPermissions");
		SystemRequirementsChecker.checkWithDefaultDialogs(this);
		callbackContext.success(1);
	}

	/**
	 * Plugin reset.
	 * Called when the WebView does a top-level navigation or refreshes.
	 */
	@Override
	public void onReset() {
        super.onReset();
		Log.i(tag, "onReset");
	}

	/**
	 * The final call you receive before your activity is destroyed.
	 */
	@Override
	public void onDestroy() {
        super.onDestroy();
		Log.i(tag, "onDestroy");
	}

    /**
	 * Entry point for JavaScript calls.
	 */
	@Override
	public boolean execute(String action, CordovaArgs args, final CallbackContext callbackContext) throws JSONException {
        Log.i(tag, "execute " + action);

		if (action == null) {
			return false;
		}

		if ("requestAlwaysAuthorization".equals(action) || "requestWhenInUseAuthorization".equals(action)) {
			requestPermissions(callbackContext);
			return true;
		}

		return false;
	}

}