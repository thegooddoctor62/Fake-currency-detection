% test_ChannelB.m
% A script to test the full logic for Channel B (Frequency Analysis).

clear; clc; close all;

% --- 1. Full Preprocessing Pipeline ---
disp('--- Running Full Preprocessing to get a clean image ---');
% (This section runs our full, finalized preprocessing pipeline)
ref_img = imread('reference_note_100.png');
test_img_raw = imread('test_note_fake_2.jpg');
% ... (Full preprocessing logic)
test_img_standardized = applyNoiseFilter('test_note_fake_2.jpg');
%test_img_standardized = imrotate(test_img_denoised, -90);
ref_height = size(ref_img, 1);
test_img_standardized = imresize(test_img_standardized, [ref_height, NaN]);
aligned_img = warpImageAfterHomography(test_img_standardized, ref_img);
final_processed_gray = normalizeIllumination(aligned_img);
disp('--- Preprocessing Complete ---');

% --- 2. Execution of Channel B Modules ---
% Define the ROI for the vertical strip (using the same coordinates)
roi_rect = [955, 1, 65, size(final_processed_gray, 1)-70];

disp('Extracting ROI from processed test image...');
test_roi = extractROI(final_processed_gray, roi_rect);

disp('Running analyzeFrequencySpectrum.m...');
[score, spectrum_vis] = analyzeFrequencySpectrum(test_roi);

% --- 3. Visualization and Results ---
fprintf('Channel B detection complete. \n');
fprintf('>>> FFT Signature Score: %.4f \n', score);

figure('Name', 'Channel B Test', 'NumberTitle', 'off');
subplot(1, 2, 1);
imshow(test_roi);
title('Test Image ROI');

subplot(1, 2, 2);
imshow(spectrum_vis, []);
title(['Resulting Spectrum (Score: ', num2str(score, 2), ')']);

disp('Test script finished.');

% --- Helper function for preprocessing ---
function warped_img = warpImageAfterHomography(test_img, ref_img)
    ref_gray = convertToGrayscale(ref_img);
    test_gray = convertToGrayscale(test_img);
    [ref_points, ref_features] = detectAndExtractFeatures(ref_gray);
    [test_points, test_features] = detectAndExtractFeatures(test_gray);
    [matched_points_test, matched_points_ref, ~] = ...
        matchFeaturesBetweenImages(test_points, test_features, ref_points, ref_features);
    [tform, ~] = estimateHomography(matched_points_test, matched_points_ref);
    warped_img = warpImage(test_img, ref_img, tform);
end