package com.lirmm.al3xey.multisharpfocus;

import android.graphics.Bitmap;
import android.graphics.Color;

public class Histogram {

    private int[] values = new int[256];

    public Histogram(Bitmap image) {
        //we assume the image is NOT grayscaled (but has no alpha)
        int width, height, color, red, blue, green, grey;
        Bitmap copy = image.copy(Bitmap.Config.ARGB_8888, true); //TODO see which config is best


        for (int i = 0; i < 256; i++) {
            values[i] = 0;
        }

        width = copy.getWidth();
        height = copy.getHeight();

        for (int i = 0; i < width; i++) {
            for (int j = 0; j < height; j++) {
                color = copy.getPixel(i, j);
                red = Color.red(color);
                green = Color.green(color);
                blue = Color.blue(color);
                grey = (red + green + blue) / 3;
                values[grey] = values[grey] + 1; //TODO verify that it works
            }
        }
    }

    public Histogram(Image image) {
        this(image.getBitmap());
    }

    public int[] getValues() {
        return values;
    }

    public int get(int value) {
        return values[value];
    }

    //TODO public float getVariance();

    //TODO equals
    //TODO toString

    public String toString() {
        String output = "";
        for (int i = 0; i < 256; i++) {
            output += i + " \t" + values[i] + "\n";
        }
        return output;
    }

}
