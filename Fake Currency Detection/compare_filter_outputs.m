% comprehensive_currency_analyzer.m
% Applies a wide variety of advanced signal processing techniques to the entire banknote.

clear; clc; close all;

% --- 1. Setup ---
disp('Loading reference image...');
ref_img = imread('reference_note_100.png');
ref_gray = convertToGrayscale(ref_img);

disp('Starting analysis... Each technique will open in a new window.');

% --- 2. Run All Analyses ---

%% 1. Edge / Line Detection
disp('Running Edge / Line Detection...');
% Sobel filters for horizontal and vertical edges
sobel_horiz = imfilter(ref_gray, fspecial('sobel'));
sobel_vert = imfilter(ref_gray, fspecial('sobel')');
figure('Name','1a: Vertical Edges (Sobel)','WindowState','maximized');
imshow(sobel_vert, []); title('Vertical Edge Filter (Sobel)');
figure('Name','1b: Horizontal Edges (Sobel)','WindowState','maximized');
imshow(sobel_horiz, []); title('Horizontal Edge Filter (Sobel)');

% Canny edge detection
canny_edges = edge(ref_gray, 'canny');
figure('Name','1c: Canny Edge Detection','WindowState','maximized');
imshow(canny_edges); title('Canny Edges');

%% 2. Morphological Filtering
disp('Running Morphological Filtering...');
% Use a small disk structuring element for general purpose filtering
se = strel('disk', 3);
% Top-hat filtering (extracts small bright features)
morph_tophat = imtophat(ref_gray, se);
figure('Name','2a: Top-Hat Filter','WindowState','maximized');
imshow(morph_tophat); title('Top-Hat Filter (Extracts Small Bright Features)');
% Black-hat filtering (extracts small dark features)
morph_blackhat = imbothat(ref_gray, se);
figure('Name','2b: Black-Hat Filter','WindowState','maximized');
imshow(morph_blackhat); title('Black-Hat Filter (Extracts Small Dark Features)');

%% 3. Frequency-Domain Filtering
disp('Running Frequency-Domain Filtering...');
F = fftshift(fft2(im2double(ref_gray)));
spectrum = log(1 + abs(F));
figure('Name','3a: 2D FFT Spectrum','WindowState','maximized');
imshow(spectrum, []); title('2D FFT Spectrum');

%% 4. Color / Intensity Profile Analysis
disp('Running Color & Profile Analysis...');
% Invert (Negative) Image
img_negative = imcomplement(ref_img);
figure('Name', '4a: Negative Image', 'WindowState', 'maximized');
imshow(img_negative); title('Inverted (Negative) Image');
% Hue Channel
roi_hsv = rgb2hsv(ref_img);
hue_channel = roi_hsv(:,:,1);
figure('Name','4b: Hue Channel','WindowState','maximized');
imshow(hue_channel); title('Hue Channel');
% Saturation Channel
saturation_channel = roi_hsv(:,:,2);
figure('Name','4c: Saturation Channel','WindowState','maximized');
imshow(saturation_channel); title('Saturation Channel');
% 'a*' Channel (Green-Red)
lab = rgb2lab(ref_img);
a_channel = lab(:,:,2);
figure('Name','4d: a* Channel (Green-Red)','WindowState','maximized');
imshow(a_channel, []); title('a* Channel (Green-Red)');

%% 5. Local Contrast Enhancement
disp('Running Local Contrast Enhancement...');
% CLAHE
clahe_img = adapthisteq(ref_gray);
figure('Name','5a: CLAHE','WindowState','maximized');
imshow(clahe_img); title('CLAHE (Adaptive Contrast)');
% Difference of Gaussians (DoG)
dog_img = imgaussfilt(ref_gray, 1) - imgaussfilt(ref_gray, 3);
figure('Name','5b: Difference of Gaussians','WindowState','maximized');
imshow(dog_img, []); title('Difference of Gaussians (Highlights Fine Lines)');

%% 6. Directional Filtering
disp('Running Directional Filtering...');
% Gabor Filter (Vertical)
g_vert = gabor(4, 90);
gabor_mag_vert = abs(imfilter(im2double(ref_gray), g_vert.SpatialKernel, 'conv'));
figure('Name','6a: Vertical Gabor Filter','WindowState','maximized');
imshow(gabor_mag_vert, []); title('Gabor Filter Response (Vertical)');
% Gabor Filter (Horizontal)
g_horiz = gabor(4, 0);
gabor_mag_horiz = abs(imfilter(im2double(ref_gray), g_horiz.SpatialKernel, 'conv'));
figure('Name','6b: Horizontal Gabor Filter','WindowState','maximized');
imshow(gabor_mag_horiz, []); title('Gabor Filter Response (Horizontal)');

%% 7. Simulated Angled Light
disp('Running Simulated Light Analysis...');
% Emboss Filter
emboss_filter = [-2 -1 0; -1 1 1; 0 1 2];
img_emboss = imfilter(ref_gray, emboss_filter);
figure('Name','7a: Emboss Filter','WindowState','maximized');
imshow(img_emboss, []); title('Emboss Filter (Simulated Angled Light)');

disp('--- Comprehensive Analysis Complete ---');