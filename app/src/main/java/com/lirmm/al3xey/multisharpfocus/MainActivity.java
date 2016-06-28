package com.lirmm.al3xey.multisharpfocus;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.Random;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    private ImageButton button;
    private String mCurrentPhotoPath;

    static final int REQUEST_TAKE_PHOTO = 1;
    static final int TAKE_PHOTO_CODE = 0;

    private long t1;
    private long t2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        button = (ImageButton) findViewById(R.id.imageButton1);

        button.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View arg0) {
                System.out.println("FRIDAY FRIDAY GETTIN' DOWN ON FRIDAY");
                takeSnapShots();
            }

        });
    }

    /*@Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }*/

    /*@Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }*/

    private void takeSnapShots() {
        Toast.makeText(getApplicationContext(), "Image snapshot   Started",
                Toast.LENGTH_SHORT).show();
        // here below "this" is activity context.
        SurfaceView surface = new SurfaceView(this);
        Camera camera = Camera.open();
        try {
            camera.setPreviewDisplay(surface.getHolder());
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        camera.startPreview();
        camera.takePicture(null, null, jpegCallback);
    }

    /** picture call back */
    PictureCallback jpegCallback = new PictureCallback() {
        public void onPictureTaken(byte[] data, Camera camera) {
            t1 = System.currentTimeMillis();
            Bitmap foo = BitmapFactory.decodeByteArray(data, 0, data.length);

            String root = Environment.getExternalStorageDirectory().toString();
            File myDir = new File(root + "/saved_images");
            myDir.mkdirs();
            Random generator = new Random();
            int n = 10000;
            n = generator.nextInt(n);
            String fname = "Image-" + n + ".jpg"; //TODO date
            File file = new File(myDir, fname);
            if (file.exists())
                file.delete();
            try {
                FileOutputStream out = new FileOutputStream(file);
                foo.compress(Bitmap.CompressFormat.JPEG, 90, out);
                out.flush();
                out.close();
                t2 = System.currentTimeMillis();
                sendBroadcast(new Intent(Intent.ACTION_MEDIA_MOUNTED,
                        Uri.parse("file://"
                                + Environment.getExternalStorageDirectory())));
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                camera.stopPreview();
                camera.release();
                camera = null;
                Toast.makeText(getApplicationContext(), "Image snapshot Done",
                        Toast.LENGTH_LONG).show();

                Toast.makeText(getApplicationContext(),
                        "Duration : " + (t2 - t1), Toast.LENGTH_LONG).show();
                System.out.println("Duration : " + (t2 - t1));

            }
            Log.d("error", "onPictureTaken - jpeg");
        }
    };
}
