clc
clear
close all
imtool close all
%%%%%%%%%%%%%%%
I = imread("images\i3b.png");
rf = 0.3;
J = My_Imresize_BL(I, rf);
K = uint8(imresize(double(I), rf, 'bilinear'));
figure, imshow(I, []);
figure, imshow(J, []);
figure, imshow(K, []);
immse(J, K)