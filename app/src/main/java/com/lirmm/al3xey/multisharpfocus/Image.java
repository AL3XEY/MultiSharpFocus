package com.lirmm.al3xey.multisharpfocus;

import android.graphics.Bitmap;
import android.graphics.Color;

public class Image{

    private Bitmap bitmap;

    public Image(Bitmap image){
        bitmap = image;
    }

    //TODO if isMutable()

    /*public Image sobel(){
        if (isMutable()) {
            //int threshold = 100;
            int gx, gy, tmp, color, width, height; //TODO w & h : attributes?
            double g;
            int greyscaled[][];

            width = getWidth();
            height = getHeight();
            greyscaled = new int[getWidth()][getHeight()];

            for (int i = 0; i < width; i++) {
                for (int j = 0; j < height; j++) {
                    color = getPixel(i, j);
                    greyscaled[i][j] = (Color.red(color) + Color.blue(color) + Color.green(color)) / 3;
                }
            }

            for (int i = 1; i < width - 1; i++) {
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

                    //tmp = (int) (g/8);
                    //bmp.setPixel(i, j, Color.rgb(tmp,tmp,tmp));
                }
            }
        }
    }*/

    public Image sobel(int threshold){
        Bitmap copy = bitmap.copy(Bitmap.Config.ARGB_8888, true); //TODO see which config is best
        if (copy.isMutable()) {
            //int threshold = 100;
            int gx, gy, tmp, color, width, height; //TODO w & h : attributes?
            double g;
            int greyscaled[][];

            width = copy.getWidth();
            height = copy.getHeight();
            greyscaled = new int[width][height];

            for (int i = 0; i < width; i++) {
                for (int j = 0; j < height; j++) {
                    color = copy.getPixel(i, j);
                    greyscaled[i][j] = (Color.red(color) + Color.blue(color) + Color.green(color)) / 3;
                }
            }

            for (int i = 1; i < width - 1; i++) {
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
                        tmp = Color.WHITE;
                    } else {
                        tmp = Color.BLACK;
                    }
                    copy.setPixel(i, j, tmp);
                }
            }
        }
        return new Image(copy);
    }

    public Bitmap getBitmap(){
        return bitmap;
    }

    public int getPixel(int x, int y){
        return bitmap.getPixel(x, y);
    }

    //public void/boolean setPixel(int x, int y, int color);

    //public Image copy();

}
