package com.lirmm.al3xey.multisharpfocus;

import android.graphics.Bitmap;
import android.graphics.Color;

public class Histogram {

    private int[] values = new int[255];

    public Histogram(Bitmap image){
        //we assume the image is NOT grayscaled (but has no alpha)
        int width, height, color, red, blue, green, grey;

        for(int i=0;i<256;i++){
            values[i]=0;
        }

        width = image.getWidth();
        height = image.getHeight();

        for(int i=0;i<width;i++) {
            for(int j=0;j<height;j++) {
                color = image.getPixel(0, 0);
                red = Color.red(color);
                green = Color.green(color);
                blue = Color.blue(color);
                grey = (int)(red + green + blue)/3;
                values[grey]++; //TODO verify that it works
            }
        }
    }

    public int[] getValues(){
        return values;
    }

    public int get(int value){
        return values[value];
    }

    //TODO equals
    //TODO toString

}
