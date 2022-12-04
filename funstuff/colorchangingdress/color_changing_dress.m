% The Color Changing Dress
% Author: Chetan Tonde
% Version: 1.0
% MALLAB version R2015a
clear all;
clc;
close all;

img = imread('dress-7.jpg'); % Read the image
img_crop = img(401:623,63:371,:,:); % Crop the roughly center part
  
red = img_crop(:,:,1);             % Get the red channel
green = img_crop(:,:,2);           % Get the green channel
blue = img_crop(:,:,3);             % Get the blue channel

subplot(3,3,1);                     
imshow(img);                    % show the original image
title('#TheDress');
subplot(3,3,2);                     
imshow(img_crop);               % show the cropped part
title('#TheColors');
subplot(3,3,3);
histogram(blue,'FaceColor','b');     % Display blue channel histogram
title('#TheBlueColors');
subplot(3,3,4); 
histogram(red,'FaceColor','r');       % Display red channel histogram   
title('#TheRedColors');
subplot(3,3,5);
histogram(green,'FaceColor','g');     % Display green channel histogram
title('#TheGreenColors');
%%  fit a gaussian mixture model to figure out the dominanat color
gmfit_red = fitgmdist(double(red(:)),1);
gmfit_green = fitgmdist(double(green(:)),2);
gmfit_blue = fitgmdist(double(blue(:)),2);

color1 = uint8([gmfit_red.mu gmfit_green.mu(1) gmfit_blue.mu(1)]);
color2 = uint8([gmfit_red.mu gmfit_green.mu(2) gmfit_blue.mu(1)]);
color3 = uint8([gmfit_red.mu gmfit_green.mu(1) gmfit_blue.mu(2)]);
color4 = uint8([gmfit_red.mu gmfit_green.mu(2) gmfit_blue.mu(2)]);

% create color patches to chooose from 
img_patch1 = repmat(reshape(color1,1,1,3), [128,128]);
img_patch2 = repmat(reshape(color2,1,1,3), [128,128]);
img_patch3 = repmat(reshape(color3,1,1,3), [128,128]);
img_patch4 = repmat(reshape(color4,1,1,3), [128,128]);
%%
% load the 500+ color names from http://cloford.com/resources/colours/500col.htm !!
load('ColorNames.mat');     
nColors = size(RGB,1);
% find the best match color names for all patches using smallest error
[colorErr, color1Index] = min(sum((repmat(double(color1),nColors, 1) - RGB).^2,2));
[colorErr, color2Index] = min(sum((repmat(double(color2),nColors, 1) - RGB).^2,2));
[colorErr, color3Index] = min(sum((repmat(double(color3),nColors, 1) - RGB).^2,2));
[colorErr, color4Index] = min(sum((repmat(double(color4),nColors, 1) - RGB).^2,2));
%% Display your choices!
subplot(3,3,6);
imshow(img_patch1);   % Show color choice 1
title(sprintf('RGB:(%3d,%3d,%3d) - Hex:%s, Name: %s',color1(1),color1(2),color1(3),...
    Hex{color1Index(1)}, ColourName{color1Index}));
subplot(3,3,7);
imshow(img_patch2); % Show color choice 2
title(sprintf('RGB:(%3d,%3d,%3d) - Hex:%s, Name: %s',color2(1),color2(2),color2(3),...
    Hex{color1Index(1)},  ColourName{color2Index} ));
subplot(3,3,8);
imshow(img_patch3);  % Show color choice 3
title(sprintf('RGB:(%3d,%3d,%3d) - Hex:%s, Name: %s',color3(1),color3(2),color3(3),...
    Hex{color1Index(1)},  ColourName{color3Index} ));
subplot(3,3,9);
imshow(img_patch4);  % Show color choice 4
title(sprintf('RGB:(%3d,%3d,%3d) - Hex:%s, Name: %s',color4(1),color4(2),color4(3),...
    Hex{color1Index(1)},  ColourName{color4Index} ));