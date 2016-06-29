package com.lirmm.al3xey.multisharpfocus;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Rect;
import android.hardware.Camera;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.SurfaceHolder;
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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class MainActivity extends AppCompatActivity implements Camera.AutoFocusCallback{

    private static boolean DEBUG = true;
    private ImageButton pictureButton;
    private ImageButton focusButton;
    private TextView focalLengthValueTextView;
    private Camera camera;
    private SurfaceView preview;
    private SurfaceHolder previewHolder;
    private boolean safeToTakePicture = false;

    private Camera.PictureCallback pictureCallback = new Camera.PictureCallback() {
        public void onPictureTaken(byte[] data, Camera camera) {
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
                camera.startPreview();
            }
            Log.d("error", "onPictureTaken - jpeg");
            safeToTakePicture = true;
        }
    };

    private SurfaceHolder.Callback surfaceCallback=new SurfaceHolder.Callback(){

        public void surfaceCreated(SurfaceHolder holder) {
            try {
                camera.setPreviewDisplay(previewHolder);
            }   catch (Throwable t) {
                Log.e("surfaceCallback",
                        "Exception in setPreviewDisplay()", t);
            }
        }

        public void surfaceChanged(SurfaceHolder holder,int format, int width,int height) {
            Camera.Parameters params;
            params = camera.getParameters();
            params.setRotation(90);
            Camera.Size size = getBestPreviewSize(width, height, params);
            Camera.Size pictureSize=getSmallestPictureSize(params);
            if (size != null && pictureSize != null) {
                params.setPreviewSize(size.width, size.height);
                params.setPictureSize(pictureSize.width,
                        pictureSize.height);
                camera.setParameters(params);
                camera.setDisplayOrientation(90);
                try {
                    camera.setPreviewDisplay(previewHolder);
                }catch(IOException e){
                    e.printStackTrace();
                }
                camera.startPreview();
                safeToTakePicture = true;
            }
        }

        public void surfaceDestroyed(SurfaceHolder holder) {

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        safeCameraOpen();

        preview = (SurfaceView)findViewById(R.id.surfaceView);
        previewHolder=preview.getHolder();
        previewHolder.addCallback(surfaceCallback);
        previewHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);

        focalLengthValueTextView = (TextView) findViewById(R.id.focalLengthValueTextView);
        pictureButton = (ImageButton) findViewById(R.id.takePictureButton);
        pictureButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View arg0) {
                if (safeToTakePicture) {
                    //TODO MediaPlayer for sound
                    takePicture();
                    safeToTakePicture = false;
                }
            }
        });
        focusButton = (ImageButton) findViewById(R.id.focusButton);
        focusButton.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View arg0) {
                focusTest();
            }
        });
    }

    public void focusTest(){
        Camera.Parameters parameters = camera.getParameters();
        parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
        List<Camera.Area> focusAreas = new ArrayList<Camera.Area>();
        Rect focusRect = new Rect(10,10,50,70);
        focusAreas.add(new Camera.Area(focusRect, 1000));
        parameters.setFocusAreas(focusAreas);

        /*if (meteringAreaSupported) {
            parameters.setMeteringAreas(Lists.newArrayList(new Camera.Area(meteringRect, 1000)));
        }*/

        camera.setParameters(parameters);
        camera.autoFocus(this);
    }

    public void onAutoFocus(boolean success, Camera camera){
        //
    }

    private void takePicture(){
        long startTime=0, endTime=0;
        if(DEBUG) {
            //We put the display, log, etc here to avoid time loss
            Toast.makeText(getApplicationContext(), "Taking picture...",
                    Toast.LENGTH_SHORT).show();
            float focalLength = camera.getParameters().getFocalLength();
            focalLengthValueTextView.setText(String.valueOf(focalLength)); //3.5

            //camera.getParameters().getFocusAreas(); //null

            //camera.getParameters().getFocusDistances();

            startTime = System.currentTimeMillis();
        }

        camera.takePicture(null, null, pictureCallback);
        if(DEBUG) {
            endTime = System.currentTimeMillis();
            Toast.makeText(getApplicationContext(), "Picture taken! It took " + (endTime - startTime) + "ms",
                    Toast.LENGTH_SHORT).show();
        }
    }

    private Camera.Size getBestPreviewSize(int width, int height,
                                           Camera.Parameters parameters) {
        Camera.Size result=null;

        for (Camera.Size size : parameters.getSupportedPreviewSizes()) {
            if (size.width <= width && size.height <= height) {
                if (result == null) {
                    result=size;
                }
                else {
                    int resultArea=result.width * result.height;
                    int newArea=size.width * size.height;

                    if (newArea > resultArea) {
                        result=size;
                    }
                }
            }
        }

        return(result);
    }

    private Camera.Size getSmallestPictureSize(Camera.Parameters parameters) {
        Camera.Size result=null;

        for (Camera.Size size : parameters.getSupportedPictureSizes()) {
            if (result == null) {
                result=size;
            }
            else {
                int resultArea=result.width * result.height;
                int newArea=size.width * size.height;

                if (newArea < resultArea) {
                    result=size;
                }
            }
        }

        return(result);
    }

    private boolean safeCameraOpen(int id) {
        boolean opened = false;

        try {
            releaseCameraAndPreview();
            camera = Camera.open(id);
            opened = (camera != null);
        } catch (Exception e) {
            Log.e(getString(R.string.app_name), "failed to open Camera");
            e.printStackTrace();
        }

        return opened;
    }

    private boolean safeCameraOpen() {
        boolean opened = false;

        try {
            releaseCameraAndPreview();
            camera = Camera.open();
            opened = (camera != null);
        } catch (Exception e) {
            Log.e(getString(R.string.app_name), "failed to open Camera");
            e.printStackTrace();
        }

        return opened;
    }

    private void releaseCameraAndPreview() {
        //preview.setCamera(null);
        if (camera != null) {
            camera.release();
            //camera.stopPreview();
            camera = null;
        }
    }

    @Override
    protected void onPause() {
        releaseCameraAndPreview();
        super.onPause();
    }

    @Override
    protected void onStop() {
        releaseCameraAndPreview();
        super.onStop();
    }

    @Override
    protected void onResume() {
        super.onResume();
        safeCameraOpen();
    }

    @Override
    protected void onStart() {
        super.onStart();
        safeCameraOpen();
    }

    @Override
    protected void onDestroy() {
        releaseCameraAndPreview();
        super.onDestroy();
    }

}
