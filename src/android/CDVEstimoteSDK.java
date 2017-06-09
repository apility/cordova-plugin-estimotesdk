package no.apility.cordova;

import android.util.Log;
import android.app.Application;
import android.content.Context;

import com.estimote.coresdk.common.requirements.SystemRequirementsChecker;

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
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        Log.i(tag, "initialize");
    }

	public boolean requestAlwaysAuthorization(final CallbackContext callbackContext) {
		Log.i(tag, "requestAlwaysAuthorization");
		if (SystemRequirementsChecker.checkWithDefaultDialogs(this.cordova.getActivity())) {
			callbackContext.success(1);
			return true;
		}
		callbackContext.error(0);
		return false;
	}

	public boolean requestWhenInUseAuthorization(final CallbackContext callbackContext) {
		Log.i(tag, "requestWhenInUseAuthorization");
		if (requestAlwaysAuthorization(callbackContext)) {
			callbackContext.success(1);
			return true;
		}
		callbackContext.error(0);
		return false;
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
	public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Log.i(tag, "execute " + action);

		if (action == null) {
			return false;
		}

		if ("requestAlwaysAuthorization".equals(action)) {
			return requestAlwaysAuthorization(callbackContext);
		}

		if ("requestWhenInUseAuthorization".equals(action)) {
			return requestWhenInUseAuthorization(callbackContext);
		}

		return false;
	}

}