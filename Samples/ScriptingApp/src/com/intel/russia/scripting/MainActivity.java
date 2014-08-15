package com.intel.russia.scripting;

import java.io.BufferedReader;
import java.io.InputStreamReader;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
	}

	public void parseScript(View v) {
		// get the script
		String script = ((EditText) findViewById(R.id.editText)).getText()
				.toString();

		// TODO parse with inteligence in mind :)

		boolean shellCommand = false;
		if (script.contains("battery"))
			shellCommand = true;

		if (shellCommand) {
			executeShell("dumpsys battery");
		} else {
			Toast.makeText(this, "Not a dumpsys battery", Toast.LENGTH_LONG)
					.show();
		}

	}

	public void executeShell(String cmd) {
		try {

			Process script = Runtime.getRuntime().exec(cmd);
			BufferedReader in = new BufferedReader(new InputStreamReader(
					script.getInputStream()));

			String line = null;
			while ((line = in.readLine()) != null) {
				Log.i("BATTERY", "Battery stats: " + line);
			}
		} catch (Exception ex) {
		}
	}

}
