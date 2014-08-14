package com.intel.russia.yandex;

import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;
import android.app.Activity;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends Activity {
	
	String request;
	String response;
	TextView displayWeatherText;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		displayWeatherText = (TextView) findViewById(R.id.displayWeatherText);
	}
	
	public void showWeatherClick(View v)
	{
		String city = ((EditText) findViewById(R.id.inputText)).getText().toString();
		city = city.replaceAll(" ", "%20");
		request = "http://api.openweathermap.org/data/2.5/weather?q=" + city
				+ ",ru&units=metric";
		
		Log.d("Weather", request);

		// get the data in an AsyncTask
		new WeatherUpdater().execute();
	}
	

	class WeatherUpdater extends AsyncTask<String, Integer, String> {
		private ProgressDialog progress;

		@Override
		protected String doInBackground(String... statuses) {
			try {
				// transporter for our in->out call
				HttpClient client = new DefaultHttpClient();
				HttpGet httpget = new HttpGet(request);
				response = client.execute(httpget, new BasicResponseHandler());

				return response;

			} catch (Throwable e) {
				Log.d("Weather", e.getMessage());
				return "Error on posting" + e.getMessage();
			}
		}

		@Override
		protected void onPostExecute(String result) {
			progress.dismiss();

			// parse the JSON and get the temperature
			try {
				JSONObject jObj = new JSONObject(response);
				JSONObject jsonObj = jObj.getJSONObject("main");
				displayWeatherText.setText(new Float(jsonObj.getString("temp"))
						.intValue() + "\u00B0");
			
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}

		@Override
		protected void onPreExecute() {
			progress = ProgressDialog.show(MainActivity.this,
					"Get the weather", "Please wait ....");
		}

	}


}
