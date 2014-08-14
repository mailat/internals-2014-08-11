package com.intel.shanghai.yamba;

import com.marakana.android.yamba.clientlib.YambaClient;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class StatusActivity extends Activity{
	TextView labelCounter;
	EditText editText;
	YambaClient client = null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_status);
		
		Log.d("Yamba", "StatusActivity - onCreate");
		
		//we get reference to the EditText and we read the status
		editText = (EditText) findViewById(R.id.editText);
		
		
		labelCounter = (TextView) findViewById(R.id.labelCounter);
		//labelCounter.setText(Integer.toString(140 - labelCounter.getText().length()));

		// watch for the number of inserted characters
		TextWatcher watcher = new TextWatcher() {

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
			}
			
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}
			
			@Override
			public void afterTextChanged(Editable s) {
				int count = 140 - s.length();
				labelCounter.setText(Integer.toString(count));
				Log.d("Yamba", "Chars left:" + count );
				
				// if we have 50 chars left we change the colour to RED
				if (count<50)
					labelCounter.setTextColor(Color.RED);
				else
					labelCounter.setTextColor(Color.GREEN);
			}
		
		};
		editText.addTextChangedListener(watcher);
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.status, menu);
		return true;
	}

	public void postTwitterUpdate(View v) {
		//call the AsyncTask poster to send the text	
		String editTextPost = editText.getText().toString();
		new PostToTwitter().execute(editTextPost);
	}
	
	class PostToTwitter extends AsyncTask<String, Integer, String> {
		private ProgressDialog progress;
		
		@Override
		protected String doInBackground(String... statuses) {

			try {
				// post on Twitter
				((YambaApplication)getApplication()).getYambaClient().postStatus(statuses[0]);
				return "Posted ok the text" + statuses[0];
			} catch (Throwable e) {
				//e.printStackTrace();
				Log.d("Yamba", e.getMessage());
				return "Error on posting" + e.getMessage();
			}
		}

		@Override
		protected void onPostExecute(String result) {
			progress.dismiss();
			Toast.makeText(StatusActivity.this, result, Toast.LENGTH_LONG).show();
		}

		@Override
		protected void onPreExecute() {
			progress = ProgressDialog.show(StatusActivity.this, "Posting to yamba server", "Please wait ....");
		}

	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here
		int id = item.getItemId();
		
		if (id == R.id.action_settings) {
			startActivity(new Intent(this, PrefsActivity.class));
		}
		else if (id == R.id.actionServiceStart) {
			startService(new Intent(this, UpdaterService.class));
		}
		else if (id == R.id.actionServiceStop) {
			stopService(new Intent(this, UpdaterService.class));
		}	
		else if (id == R.id.actionServicerefresh) {
			startService(new Intent(this, RefreshService.class));
		}			
		return true;
	}

}
