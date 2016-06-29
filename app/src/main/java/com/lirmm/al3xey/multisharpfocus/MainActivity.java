package com.lirmm.al3xey.multisharpfocus;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class MainActivity extends AppCompatActivity {

    private static boolean DEBUG = true;
    private ImageButton button;
    private TextView focalLengthValueTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        focalLengthValueTextView = (TextView) findViewById(R.id.focalLengthValueTextView);

        button = (ImageButton) findViewById(R.id.imageButton1);

        button.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                takeSnapShots();
            }

        });
    }

    private void takeSnapShots() {
        Toast.makeText(getApplicationContext(), "Image snapshot   Started",
                Toast.LENGTH_SHORT).show();
        // here below "this" is activity context.
        SurfaceView surface = new SurfaceView(this);
        Camera camera = Camera.open();

        float focalLength = camera.getParameters().getFocalLength();
        focalLengthValueTextView.setText(String.valueOf(focalLength));

        //camera.getParameters().getFocusAreas(); //null

        //camera.getParameters().getFocusDistances();

        try {
            camera.setPreviewDisplay(surface.getHolder());
        } catch (IOException e) {
            e.printStackTrace();
        }
        camera.startPreview();
        try {
            Thread.sleep(250);
        }catch(InterruptedException e){}
        camera.takePicture(null, null, jpegCallback);
    }

    PictureCallback jpegCallback = new PictureCallback() {
        public void onPictureTaken(byte[] data, Camera camera) {
                long startTime=0, endTime=0;
            if(DEBUG) {
                startTime = System.currentTimeMillis();
            }
            Bitmap foo = BitmapFactory.decodeByteArray(data, 0, data.length);

            String root = Environment.getExternalStorageDirectory().toString();
            File myDir = new File(root + "/MultiSharpFocus");
            myDir.mkdirs();

            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss"); // TODO or singleton giving unique ID every app start
            Calendar cal = Calendar.getInstance();
            String fname = dateFormat.format(cal.getTime()) + ".jpg";
            if(DEBUG) {
                Toast.makeText(getApplicationContext(),
                        fname, Toast.LENGTH_LONG).show();
            }

            File file = new File(myDir, fname);
            if (file.exists())
                file.delete();
            try {
                FileOutputStream out = new FileOutputStream(file);
                foo.compress(Bitmap.CompressFormat.JPEG, 90, out); //TODO discuss compression
                out.flush();
                out.close();
                sendBroadcast(new Intent(Intent.ACTION_MEDIA_MOUNTED,
                        Uri.parse("file://"
                                + Environment.getExternalStorageDirectory())));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                camera.stopPreview();
                //TODO delay?
                camera.release();
                camera = null;
                if(DEBUG) {
                    endTime = System.currentTimeMillis();
                    Toast.makeText(getApplicationContext(), "Image snapshot Done",
                            Toast.LENGTH_LONG).show();

                    Toast.makeText(getApplicationContext(),
                            "Duration : " + (endTime - startTime) + "ms", Toast.LENGTH_LONG).show();
                }

            }
            Log.d("error", "onPictureTaken - jpeg");
        }
    };
}
