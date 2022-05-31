clc
clear
%close all
%imtool close all
%%%%%%%%%%%%%%%%
n = 20;
path1 = 'images\Q3\DRIVE\Test\';
path2 = 'images\Q3\DRIVE\Training\';
path = path1;
temp1 = imread([path 'images\1_test.tif']);
temp2 = imread([path '1st_manual\1_manual1.gif']);
images = uint8(zeros([n size(temp1)]));
first_manual = uint8(zeros([n size(temp2)]));
second_manual = uint8(zeros([n size(temp2)]));
mask = uint8(zeros([n size(temp2)]));
for i = 1: n
    images(i, :, :, :) = imread([path 'images\' num2str(i) '_test.tif']);
    first_manual(i, :, :, :) = imread([path '1st_manual\' num2str(i) '_manual1.gif']);
    second_manual(i, :, :, :) = imread([path '2nd_manual\' num2str(i) '_manual2.gif']);
    mask(i, :, :, :) = imread([path 'mask\' num2str(i) '_test_mask.gif']);
end
%%%%%%%%%%%%%%%%%%%%%%%%enhancing lines in 12 directions using opening operation
linearly_opened_images = images;
for i = 1: n
    for j = 1: 15: 180
        se = strel('line', 7, j);
        linearly_opened_images(i, :, :, :) = imopen(squeeze(linearly_opened_images(i, :, :, :)), se);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%sharpening
sharped_images = linearly_opened_images;
for i = 1: n
    sharped_images(i, :, :, :) = 255 - imsharpen(squeeze(sharped_images(i, :, :, :)), 'Radius', 10, 'Amount', 10);
end
%%%%%%%%%%%%%%%%%%%%%%%%reduce noise
noise_canceled_images = sharped_images;
% for i = 1: n
%     noise_canceled_images(i, :, :, 1) = modefilt(squeeze(noise_canceled_images(i, :, :, 1)), [7 7]);
%     noise_canceled_images(i, :, :, 2) = modefilt(squeeze(noise_canceled_images(i, :, :, 2)), [7 7]);
%     noise_canceled_images(i, :, :, 3) = modefilt(squeeze(noise_canceled_images(i, :, :, 3)), [7 7]);
% end
%%%%%%%%%%%%%%%%%%%%%%%%thresholding
otsu_images = noise_canceled_images;
for i = 1: n
    S = imfilter(squeeze(otsu_images(i, :, :, :)), fspecial('average', [21 21]));
    K = 1.02;
    T = K * S;
    otsu_images(i, :, :, :) = squeeze(otsu_images(i, :, :, :)) > T;
end
%%%%%%%%%%%%%%%%%%%%%%%%mask
final_images = otsu_images;
for i = 1: n
    for j = 1: size(final_images(i, :, :, :), 2)
        for k = 1: size(final_images(i, :, :, :), 3)
            if (mask(i, j, k) == 0)
                final_images(i, j, k, 1) = 0;
                final_images(i, j, k, 2) = 0;
                final_images(i, j, k, 3) = 0;
            end
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%calc parameters
sensitivity = double(zeros([1 n]));
specificity = double(zeros([1 n]));
accuracy = double(zeros([1 n]));
for i = 1: n
    [tp, tn, fp, fn] = calcParameters(squeeze(final_images(i, :, :, 2)), squeeze(first_manual(i, :, :)));
    sensitivity(i) = double(tp / (tp + fn));
    specificity(i) = double(tn / (tn + fp));
    accuracy(i) = double((tp + tn) / (tp + tn + fp + fn));
end
sen_mean = mean(sensitivity)
spe_mean = mean(specificity)
acc_mean = mean(accuracy)
% 
% sen_mean + spe_mean + acc_mean










%%%%%%%%%%%%%%%%%%%%%%%%blur
% blured_images = sharped_images;
% h = fspecial('gaussian', 7, 0.5);
% for i = 1: n
%     blured_images(i, :, :, :) = imfilter(squeeze(blured_images(i, :, :, :)), h);
% end
%%%%%%%%%%%%%%%%%%%%%%%%thresholding
%otsu_images = sharped_images;
% for i = 1: n
%     level = multithresh(otsu_images(i, :, :, :), 3);
%     otsu_images(i, :, :, :) = otsu_images(i, :, :, :) > level(3);
% end