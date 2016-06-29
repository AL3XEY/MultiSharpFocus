package com.lirmm.al3xey.multisharpfocus;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.Camera;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Surface;
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
import java.lang.reflect.Method;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class MainActivity extends AppCompatActivity {

    private static boolean DEBUG = true;
    private ImageButton button;
    private TextView focalLengthValueTextView;
    private Camera camera;
    private SurfaceView preview;
    private SurfaceHolder previewHolder;
    private boolean safeToTakePicture = false;

    private Camera.PictureCallback pictureCallback = new Camera.PictureCallback() {
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
                camera.startPreview();
                if(DEBUG) {
                    endTime = System.currentTimeMillis();
                    Toast.makeText(getApplicationContext(), "Image snapshot Done",
                            Toast.LENGTH_LONG).show();

                    Toast.makeText(getApplicationContext(),
                            "Duration : " + (endTime - startTime) + "ms", Toast.LENGTH_LONG).show();
                }

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
                //Toast.makeText(this, t.getMessage(), Toast.LENGTH_LONG).show();
            }
        }

        public void surfaceChanged(SurfaceHolder holder,int format, int width,int height) {
            Camera.Parameters params;
            params = camera.getParameters();
            //params.setFlashMode(Camera.Parameters.FLASH_MODE_ON);
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

        /*if (Integer.parseInt(Build.VERSION.SDK) >= 8)
            setDisplayOrientation(camera, 90);
        else {
            Camera.Parameters p = camera.getParameters();
            if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT) {
                p.set("orientation", "portrait");
                p.set("rotation", 90);
            }
            if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
                p.set("orientation", "landscape");
                p.set("rotation", 90);
            }
            camera.setParameters(p);
        }*/

        //camera.setDisplayOrientation(90);

        //setCameraDisplayOrientation(this, 0, camera);

        Camera.Parameters parameters = camera.getParameters();
        parameters.setRotation(90);
        camera.setParameters(parameters);

        camera.setDisplayOrientation(90);
        try {
            camera.setPreviewDisplay(previewHolder);
        }catch(IOException e){
            e.printStackTrace();
        }

        focalLengthValueTextView = (TextView) findViewById(R.id.focalLengthValueTextView);
        button = (ImageButton) findViewById(R.id.imageButton1);
        button.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View arg0) {
                if (safeToTakePicture) {
                    //TODO MediaPlayer for sound
                    takePicture();
                    safeToTakePicture = false;
                }
            }
        });
    }

    public static void setCameraDisplayOrientation(Activity activity,
                                                   int cameraId, android.hardware.Camera camera) {
        android.hardware.Camera.CameraInfo info =
                new android.hardware.Camera.CameraInfo();
        android.hardware.Camera.getCameraInfo(cameraId, info);
        int rotation = activity.getWindowManager().getDefaultDisplay()
                .getRotation();
        int degrees = 0;
        switch (rotation) {
            case Surface.ROTATION_0: degrees = 0; break;
            case Surface.ROTATION_90: degrees = 90; break;
            case Surface.ROTATION_180: degrees = 180; break;
            case Surface.ROTATION_270: degrees = 270; break;
        }

        int result;
        if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
            result = (info.orientation + degrees) % 360;
            result = (360 - result) % 360;  // compensate the mirror
        } else {  // back-facing
            result = (info.orientation - degrees + 360) % 360;
        }
        camera.setDisplayOrientation(result);
    }

    protected void setDisplayOrientation(Camera camera, int angle){
        Method downPolymorphic;
        try
        {
            downPolymorphic = camera.getClass().getMethod("setDisplayOrientation", int.class);
            if (downPolymorphic != null)
                downPolymorphic.invoke(camera, angle);
        }
        catch (Exception e1)
        {
        }
    }

    private void takePicture(){
        Toast.makeText(getApplicationContext(), "Image snapshot   Started",
                Toast.LENGTH_SHORT).show();
        // here below "this" is activity context.

        float focalLength = camera.getParameters().getFocalLength();
        focalLengthValueTextView.setText(String.valueOf(focalLength)); //3.5

        //camera.getParameters().getFocusAreas(); //null

        //camera.getParameters().getFocusDistances();

        camera.takePicture(null, null, pictureCallback);
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
