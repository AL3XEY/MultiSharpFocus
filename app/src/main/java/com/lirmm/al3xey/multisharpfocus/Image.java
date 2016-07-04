package com.lirmm.al3xey.multisharpfocus;

import android.graphics.Bitmap;
import android.graphics.Color;

public class Image {

    private Bitmap bitmap;

    public Image(Bitmap image) {
        bitmap = image;
    }


    public Bitmap getBitmap() {
        return bitmap;
    }

    public int getPixel(int x, int y) {
        return bitmap.getPixel(x, y);
    }

    public int getWidth() {
        return bitmap.getWidth();
    }

    public int getHeight() {
        return bitmap.getHeight();
    }

    //TODO? public Image copy();

    //TODO public Image sobel(); //returns the grayscale sobel image

    public Image sobel(int threshold) {
        Bitmap copy = bitmap.copy(Bitmap.Config.ARGB_8888, true); //TODO see which config is best
        if (copy.isMutable()) {
            int gx, gy, tmp, color, width, height, black, white;
            double g;
            int greyscaled[][];

            width = getWidth();
            height = getHeight();
            greyscaled = new int[width][height];

            black = Color.rgb(0, 0, 0);
            white = Color.rgb(255, 255, 255);

            for (int i = 0; i < width; i++) {
                for (int j = 0; j < height; j++) {
                    color = copy.getPixel(i, j);
                    greyscaled[i][j] = (Color.red(color) + Color.blue(color) + Color.green(color)) / 3;
                }
            }

            for (int i = 1; i < width - 1; i++) { //TODO pixels on the border = 0
                for (int j = 1; j < height - 1; j++) {
                    gx = (-greyscaled[i - 1][j - 1]
                            - 2 * greyscaled[i][j - 1]
                            - greyscaled[i + 1][j - 1]
                            + greyscaled[i - 1][j + 1]
                            + 2 * greyscaled[i][j + 1]
                            + greyscaled[i + 1][j + 1]);

                    gy = (-greyscaled[i - 1][j - 1]
                            + greyscaled[i + 1][j - 1]
                            - 2 * greyscaled[i - 1][j]
                            + 2 * greyscaled[i + 1][j]
                            - greyscaled[i - 1][j + 1]
                            + greyscaled[i + 1][j + 1]);
                    g = Math.sqrt(gx * gx + gy * gy);
                    if (g > threshold) {
                        //tmp = Color.WHITE;
                        tmp = Color.rgb(255, 255, 255);
                    } else {
                        //tmp = Color.BLACK;
                        tmp = Color.rgb(0, 0, 0);
                    }
                    copy.setPixel(i, j, tmp);
                }
            }

            for (int i = 0; i < width; i++) {
                copy.setPixel(i, 0, black);
                copy.setPixel(i, height-1, black);
            }

            for (int j = 0; j < height; j++) {
                copy.setPixel(0, j, black);
                copy.setPixel(width-1, j, black);
            }
        }
        return new Image(copy);
    }

    //TODO public Image laplacian();
    //TODO public Image fourier();

    public Histogram getHistogram() {
        return new Histogram(bitmap);
    }

}
