package com.cowdino.iwt;

import android.app.Activity;
import android.os.Bundle;
import android.support.wearable.view.WatchViewStub;
import android.util.Log;
import android.view.View;
import android.widget.Button;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final WatchViewStub stub = (WatchViewStub) findViewById(R.id.watch_view_stub);
        stub.setOnLayoutInflatedListener(new WatchViewStub.OnLayoutInflatedListener() {
            @Override
            public void onLayoutInflated(WatchViewStub stub) {
                Button previousButton = (Button)stub.findViewById(R.id.previous_button);
                Button nextButton = (Button)stub.findViewById(R.id.next_button);
                Button startButton = (Button)stub.findViewById(R.id.start_button);

                previousButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        showPreviousImage();
                    }
                });

                nextButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        showNextImage();
                    }
                });

                startButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Button b = (Button)v;
                        if(b.getText().toString().equalsIgnoreCase(
                                v.getContext().getResources().getString(R.string.start))) {
                            startAutoPlay();
                            b.setText(R.string.stop);
                        } else {
                            stopAutoPlay();
                            b.setText(R.string.start);
                        }
                    }
                });
            }
        });

    }

    private void stopAutoPlay() {
        Log.v(getClass().getName(), "stopAutoPlay");
    }

    private void startAutoPlay() {
        Log.v(getClass().getName(), "startAutoPlay");
    }

    private void showNextImage() {
        Log.v(getClass().getName(), "showNextImage");
    }

    private void showPreviousImage() {
        Log.v(getClass().getName(), "showPreviousImage");
    }
}
