%testbench.m
%

clear all;
clc;

%graphics_toolkit('fltk');
graphics_toolkit('gnuplot');

full = 0;

%sharp_detect('img/01.jpg', full); %bad
%sharp_detect('img/02.jpg', full); %good
%sharp_detect('img/kidsblur.ppm', full); %very good
%sharp_detect('img/lena.ppm', full); %good

%sharp_detect('img/test1.jpg', full); %good
%sharp_detect('img/test2.jpg', full); % error: rgb2gray: the input must either be an RGB image or a colormap %kind of bad
%sharp_detect('img/test3.jpg', full); %not bad
%sharp_detect('img/test4.jpg', full); %very good
sharp_detect('img/test5.jpg', full); %very good
%sharp_detect('img/test6.jpg', full); %very good
%sharp_detect('img/test7.jpg', full); %surprisingly good => noisy original image
%sharp_detect('img/test8.jpg', full); %very good

%sharp_detect('img/blur1.png', full); %not so good
%sharp_detect('img/blur2.jpg', full); %very good
%sharp_detect('img/blur3.jpg', full); %really bad, logical
%sharp_detect('img/blur4.jpg', full); %bad, logical

%sharp_detect('img/res1.jpg', full); %very good
%sharp_detect('img/res2.jpg', full); %very good
%sharp_detect('img/res3.jpg', full); %very good
%sharp_detect('img/res4.jpg', full); %very good
%sharp_detect('img/res5.jpg', full); %slow but good
%sharp_detect('img/res6.jpg', full); %very slow, quite good

%sharp_detect('img/sharp1.jpg', full); %kind of good : clouds + ground not really detected
%sharp_detect('img/sharp2.jpg', full); %kind of good : clouds + regular walls not detected
%sharp_detect('img/sharp3.jpg', full); %kind of bad
%sharp_detect('img/sharp4.jpg', full); %bad : clouds not detected at all

pause;
