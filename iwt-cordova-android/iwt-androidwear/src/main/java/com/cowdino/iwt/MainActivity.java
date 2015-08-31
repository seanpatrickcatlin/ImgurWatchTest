package com.cowdino.iwt;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.wearable.view.WatchViewStub;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.ArrayList;

import javax.net.ssl.HttpsURLConnection;

public class MainActivity extends Activity {
    private int imageNumber;
    private int lastPageRequested;
    private boolean autoPlay;
    private String lastImageUrl;
    // private Timer getNextImageTimer; // TODO implement android timer
    private List<JSONObject> imageData;
    private GetListOfImagesTask getListOfImagesTask;
    private GetImageTask getImageTask;
    private Button previousButton;
    private Button startStopButton;
    private ImageView mainImage;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        imageNumber = -1;
        lastPageRequested = -1;
        autoPlay = false;
        lastImageUrl = "";
        // getNextImageTimer = nil; // TODO implement Android timer
        imageData = new ArrayList<>();
        getListOfImagesTask = null;
        getImageTask = null;

        setContentView(R.layout.activity_main);
        final WatchViewStub stub = (WatchViewStub) findViewById(R.id.watch_view_stub);
        stub.setOnLayoutInflatedListener(new WatchViewStub.OnLayoutInflatedListener() {
            @Override
            public void onLayoutInflated(WatchViewStub stub) {
                previousButton = (Button) stub.findViewById(R.id.previous_button);
                Button nextButton = (Button) stub.findViewById(R.id.next_button);
                startStopButton = (Button) stub.findViewById(R.id.start_button);
                mainImage = (ImageView) stub.findViewById(R.id.main_image);

                previousButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        stopAutoPlay();
                        updateImage(false);
                    }
                });

                nextButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        stopAutoPlay();
                        updateImage(true);
                    }
                });

                startStopButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (autoPlay) {
                            stopAutoPlay();
                            return;
                        }

                        startAutoPlay();
                    }
                });
            }
        });
    }

    @Override
    protected void onDestroy() {
        autoPlay = false;

        killTimer();

        if(getImageTask != null) {
            getImageTask.cancel(true);
            getImageTask = null;
        }

        if(getListOfImagesTask != null) {
            getListOfImagesTask.cancel(true);
            getListOfImagesTask = null;
        }

        super.onDestroy();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onStart() {
        super.onStart();

        showNextImage();
    }

    private void killTimer() {
        Log.v(getClass().getName(), "killTimer");

        // TODO cancel timer
        /*
        if(getNextImageTimer == null) {
            return;
        }

        [getNextImageTimer invalidate];
        getNextImageTimer = nil;
         */
    }

    private void stopAutoPlay() {
        Log.v(getClass().getName(), "stopAutoPlay");

        autoPlay = false;

        killTimer();

        if(getImageTask != null) {
            getImageTask.cancel(true);
            getImageTask = null;
        }

        if(startStopButton != null) {
            startStopButton.setText(R.string.start);
        }
    }

    private void startAutoPlay() {
        Log.v(getClass().getName(), "startAutoPlay");
        startStopButton.setText(R.string.stop);
        autoPlay = true;
        showNextImage();
    }

    private void showNextImage() {
        Log.v(getClass().getName(), "showNextImage");
        updateImage(true);
    }

    private void updateImage(boolean forwards) {
        Log.v(getClass().getName(), "updateImage: " + forwards);

        if(getImageTask != null) {
            return;
        }

        killTimer();

        if(forwards) {
            imageNumber++;
        } else {
            imageNumber--;
        }

        if(imageNumber <= 0) {
            imageNumber = 0;
            stopAutoPlay();
        }

        if(imageNumber >= imageData.size()) {
            imageNumber = imageData.size() - 1;
            getNextPageOfImages();
            stopAutoPlay();
        }

        if(imageData.size() <= 0) {
            Log.v(getClass().getName(), "no data");
            return;
        }

        if(previousButton != null) {
            previousButton.setEnabled(imageNumber > 0);
        }

        String newImageUrl = "";

        if(imageNumber < imageData.size()) {
            JSONObject imageObject = imageData.get(imageNumber);

            String imageId = "";
            int imageWidth = -1;
            int imageHeight = -1;

            try {
                imageId = imageObject.getString("id");
                imageWidth = imageObject.getInt("width");
                imageHeight = imageObject.getInt("height");
            } catch(Exception e) {
                Log.v(getClass().getName(), "Exception: " + e.toString());
            }

            int maxWidth = mainImage.getWidth();
            int maxHeight = mainImage.getHeight();

            String thumbnailModifier = "h";

            float heightScale = 1.0f;
            float widthScale = 1.0f;

            if(imageWidth > imageHeight) {
                heightScale = (imageHeight / imageWidth);
            } else {
                widthScale = (imageWidth / imageHeight);
            }

            if((maxWidth < (160*widthScale)) || (maxHeight < (160*heightScale))) {
                thumbnailModifier = "t";
            } else if((maxWidth < (320*widthScale)) || (maxHeight < (320*heightScale))) {
                thumbnailModifier = "m";
            } else if((maxWidth < (640*widthScale)) || (maxHeight < (640*heightScale))) {
                thumbnailModifier = "l";
            }

            newImageUrl = "http://i.imgur.com/" + imageId + thumbnailModifier + ".jpg";
        }

        if(newImageUrl.equalsIgnoreCase(lastImageUrl)) {
            Log.v(getClass().getName(), "Image to display is the same as the one we just displayed, returning early");
            return;
        }

        lastImageUrl = newImageUrl;

        getImageTask = new GetImageTask();
        getImageTask.execute(newImageUrl);
    }

    private void getNextPageOfImages() {
        if(getListOfImagesTask != null) {
            return;
        }

        stopAutoPlay();

        lastPageRequested++;

        String imageListUrl = "https://api.imgur.com/3/gallery/r/earthporn/time/" + lastPageRequested;

        getListOfImagesTask = new GetListOfImagesTask();
        getListOfImagesTask.execute(imageListUrl);
    }

    private class GetListOfImagesTask extends AsyncTask<String, Void, Void> {
        @Override
        protected Void doInBackground(String... params) {
            String jsonData;

            try {
                URL imageUrl= new URL(params[0]);

                HttpsURLConnection httpsConnection = (HttpsURLConnection) imageUrl.openConnection();

                try {
                    httpsConnection.setRequestMethod("GET");
                    httpsConnection.setRequestProperty("Authorization", "Client-ID cc8240616b0b518");
                    httpsConnection.connect();

                    if (httpsConnection.getResponseCode() != HttpURLConnection.HTTP_OK) {
                        Log.v(getClass().getName(),
                                "Response code [" + httpsConnection.getResponseCode() +
                                        "] when trying to download image at [" + params[0] + "]");
                        return null;
                    }

                    InputStream stream = httpsConnection.getInputStream();

                    BufferedReader br = new BufferedReader(new InputStreamReader(stream));
                    StringBuilder sb = new StringBuilder();
                    String s;

                    while((s = br.readLine()) != null) {
                        sb.append(s);
                    }

                    jsonData = sb.toString();

                    JSONObject jsonObject = new JSONObject(jsonData);

                    JSONArray dataArray = jsonObject.getJSONArray("data");

                    for(int i=0; i<dataArray.length(); i++) {
                        JSONObject thisJsonObject = dataArray.getJSONObject(i);

                        if(!thisJsonObject.getBoolean("nsfw") &&
                                !thisJsonObject.getBoolean("animated")) {
                            imageData.add(thisJsonObject);
                        }
                    }

                    br.close();

                    stream.close();
                } catch (Exception e) {
                    Log.v(getClass().getName(), "Exception: " + e.toString());
                } finally {
                    httpsConnection.disconnect();
                }
            } catch(Exception e) {
                Log.v(getClass().getName(), "Exception: " + e.toString());
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);

            getListOfImagesTask = null;

            if(this.isCancelled()) {
                return;
            }

            showNextImage();
        }
    }

    private class GetImageTask extends AsyncTask<String, Void, Void> {
        private Bitmap downloadedImage;

        @Override
        protected Void doInBackground(String... params) {
            downloadedImage = null;

            try {
                URL imageUrl= new URL(params[0]);

                HttpURLConnection httpConnection = (HttpURLConnection) imageUrl.openConnection();

                try {
                    httpConnection.setRequestMethod("GET");
                    httpConnection.connect();

                    if (httpConnection.getResponseCode() != HttpURLConnection.HTTP_OK) {
                        Log.v(getClass().getName(),
                                "Response code [" + httpConnection.getResponseCode() +
                                        "] when trying to download image at [" + params[0] + "]");
                        return null;
                    }

                    InputStream stream = httpConnection.getInputStream();

                    downloadedImage = BitmapFactory.decodeStream(stream);

                    stream.close();
                } catch (Exception e) {
                    Log.v(getClass().getName(), "Exception: " + e.toString());
                } finally {
                    httpConnection.disconnect();
                }
            } catch(Exception e) {
                Log.v(getClass().getName(), "Exception: " + e.toString());
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);

            getImageTask = null;

            if(isCancelled()) {
                return;
            }

            if(downloadedImage == null) {
                return;
            }

            mainImage.setImageBitmap(downloadedImage);

            // TODO do timer stuff
            /*
            if(self.autoPlay == YES) {
                self.getNextImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showNextImage) userInfo:nil repeats:NO];
            }
            */
        }
    }
}
