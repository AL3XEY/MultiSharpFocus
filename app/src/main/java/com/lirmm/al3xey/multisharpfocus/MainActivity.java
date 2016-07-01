package com.lirmm.al3xey.multisharpfocus;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.ImageFormat;
import android.graphics.Rect;
import android.graphics.YuvImage;
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
    private TextView infoValueTextView;
    private Camera camera;
    private SurfaceView preview;
    private SurfaceHolder previewHolder;
    private boolean safeToTakePicture = false;
    private static String OUTPUT_DIRECTORY_NAME = "MultiSharpFocus";
    private File outputDirectory;
    private DateFormat dateFormat;
    private byte[] img = new byte[286836];

    private Camera.PictureCallback jpegPictureCallback = new Camera.PictureCallback() {
        public void onPictureTaken(byte[] data, Camera camera) {

            Bitmap foo = BitmapFactory.decodeByteArray(data, 0, data.length);
            
            Calendar cal = Calendar.getInstance();
            String fileName = dateFormat.format(cal.getTime()) + ".jpg";
            if(DEBUG) {
                Toast.makeText(getApplicationContext(),
                        String.valueOf(data.length) + "bytes", Toast.LENGTH_SHORT).show();
                Toast.makeText(getApplicationContext(),
                        fileName, Toast.LENGTH_SHORT).show();
            }

            File file = new File(outputDirectory, fileName);
            if (file.exists())
                file.delete();
            try {
                /*FileOutputStream out = new FileOutputStream(file);
                foo.compress(Bitmap.CompressFormat.JPEG, 100, out); //TODO discuss compression
                out.flush();
                out.close();
                sendBroadcast(new Intent(Intent.ACTION_MEDIA_MOUNTED,
                        Uri.parse("file://"
                                + Environment.getExternalStorageDirectory())));*/
                /**********/

                FileOutputStream out = new FileOutputStream(file);

                int height = foo.getHeight();
                int width = foo.getWidth();

                //Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888); //TODO see which config is best
                //Bitmap.copy(Bitmap.Config config, boolean isMutable)
                Bitmap bmp = foo.copy(Bitmap.Config.ARGB_8888, true);

                int colour = foo.getPixel(0, 0);
                int red = Color.red(colour);
                int blue = Color.blue(colour);
                int green = Color.green(colour);
                int alpha = Color.alpha(colour);

                //bmp.setPixel(0, 0, colour);
                if (bmp.isMutable()) {
                    for (int y = 0; y < 100; y++) {
                        for (int x = 0; x < 100; x++) {
                            bmp.setPixel(x, y, Color.WHITE);
                        }
                    }
                }

                if(DEBUG) {
                    Toast.makeText(getApplicationContext(),
                            "h " + height, Toast.LENGTH_SHORT).show();
                    Toast.makeText(getApplicationContext(),
                            "w " + width, Toast.LENGTH_SHORT).show();

                    Toast.makeText(getApplicationContext(),
                            "r " + red, Toast.LENGTH_SHORT).show();
                    Toast.makeText(getApplicationContext(),
                            "g " + green, Toast.LENGTH_SHORT).show();
                    Toast.makeText(getApplicationContext(),
                            "b " + blue, Toast.LENGTH_SHORT).show();
                    Toast.makeText(getApplicationContext(),
                            "a " + alpha, Toast.LENGTH_SHORT).show();
                }

                /*int[] pix = new int[492 * 583];
                foo.getPixels(pix, 0, 492, 0, 0, 492, 583);

                for (int i = 0; i < pix.length; i++) {
                    red = (pix[i]) >> 16 & 0xff;
                    green = (pix[i]) >> 8 & 0xff;
                    blue = (pix[i]) & 0xff;
                }*/

                bmp.compress(Bitmap.CompressFormat.JPEG, 100, out); //TODO discuss compression
                out.flush();
                out.close();
                sendBroadcast(new Intent(Intent.ACTION_MEDIA_MOUNTED,
                        Uri.parse("file://"
                                + Environment.getExternalStorageDirectory())));

                /**********/
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

            //List<Camera.Area> areas = new ArrayList<Camera.Area>();
            //areas = params.getFocusAreas(); //TEST NOK : NPE
            //areas = params.getMeteringAreas(); //TEST NOK : NPE

            //float focalLength = params.getFocalLength(); //TEST OK : 3.5
            //float distances[] = new float[3];
            //params.getFocusDistances(distances); //TEST OK : 0.95 / 1.9 / Infinity
            //int fps[] = new int[2];
            //params.getPreviewFpsRange(fps); //TEST OK : 5000 / 60000
            //List<String> strings = new ArrayList<String>();
            //strings = params.getSupportedFocusModes(); //TEST OK : auto, macro, infinity, continuous-video, manual
            //List<Integer> formats = new ArrayList<Integer>();
            //formats = params.getSupportedPictureFormats();
            //focalLength = params.getZoom(); //TEST OK : 0
            //focalLength = params.getMaxNumFocusAreas(); //TEST OK : 1
            //focalLength = params.getMaxNumMeteringAreas(); //TEST OK : 9
            //focalLength = params.getMaxZoom(); //TEST OK : 10

            //infoValueTextView.setText(String.valueOf(focalLength));
            //infoValueTextView.setText(strings.toString());
            //infoValueTextView.setText(areas.toString());
            //String display = String.valueOf(distances[0]) + " " + String.valueOf(distances[1]) + " " + String.valueOf(distances[2]);
            //infoValueTextView.setText(display);
            //String display = String.valueOf(fps[0]) + " " + String.valueOf(fps[1]);
            String display = "h : " + height + " w : " + width;
            infoValueTextView.setText(display);
            //infoValueTextView.setText(formats.toString());
            //infoValueTextView.setText(String.valueOf(ImageFormat.JPEG));

        }

        public void surfaceDestroyed(SurfaceHolder holder) {

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        String root = Environment.getExternalStorageDirectory().toString();
        outputDirectory = new File(root + "/" + OUTPUT_DIRECTORY_NAME);
        outputDirectory.mkdirs();
        //if(outputDirectory.mkdirs()) {

            safeCameraOpen();

            dateFormat = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");

            preview = (SurfaceView) findViewById(R.id.surfaceView);
            previewHolder = preview.getHolder();
            previewHolder.addCallback(surfaceCallback);
            previewHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);

            infoValueTextView = (TextView) findViewById(R.id.InfoValueTextView);
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
        //}else{
            //TODO
        //}
    }

    public void focusTest(){
        Camera.Parameters parameters = camera.getParameters();
        camera.cancelAutoFocus();
        parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_AUTO);
        List<Camera.Area> focusAreas = new ArrayList<Camera.Area>();
        Rect focusRect = new Rect(-1000,-1000,0,0); //TODO between -1000 and 1000? See doc for getFocusAreas()
        focusAreas.add(new Camera.Area(focusRect, 1000));
        parameters.setFocusAreas(focusAreas);

        /*if (meteringAreaSupported) {
            //parameters.setMeteringAreas(Lists.newArrayList(new Camera.Area(meteringRect, 1000)));
        }*/

        camera.setParameters(parameters);
        camera.startPreview();
        camera.autoFocus(this);
    }

    public void onAutoFocus(boolean success, Camera camera){
        Camera.Parameters parameters = camera.getParameters();
        //parameters.setFocusMode(Camera.Parameters.FOCUS_MODE_FIXED); //TODO applications should not call autoFocus() in this mode
        //camera.cancelAutoFocus(); //TODO why doesn't this work?
        //camera.setParameters(parameters);
    }

    private void takePicture(){
        long startTime=0, endTime=0;
        if(DEBUG) {
            //We put the display, log, etc here to avoid time loss
            Toast.makeText(getApplicationContext(), "Taking picture...",
                    Toast.LENGTH_SHORT).show();
            //float focalLength = camera.getParameters().getFocalLength();
            //infoValueTextView.setText(String.valueOf(focalLength)); //3.5

            //camera.getParameters().getFocusAreas(); //null

            //camera.getParameters().getFocusDistances();

            startTime = System.currentTimeMillis();
        }

        camera.takePicture(null, null, jpegPictureCallback);
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
