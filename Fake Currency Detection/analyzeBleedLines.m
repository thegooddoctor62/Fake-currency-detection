function [score, roi_rect_left, roi_rect_right] = analyzeBleedLines(aligned_color_image)
%analyzeBleedLines Dynamically finds and counts bleed lines in search zones.

    % --- 1. Define Wider Search Zones ---
    zone_rect_left = [10, 150, 90, 200]; 
    zone_rect_right = [1580, 150, 90, 200]; 

    % --- 2. Analyze Left Side ---
    zone_left_color = extractROI(aligned_color_image, zone_rect_left);
    lab_left = rgb2lab(zone_left_color);
    L_channel_left = lab_left(:,:,1); % Use Lightness channel
    profile_left = sum(L_channel_left, 1); % Create 1D profile
    
    % Find peaks by inverting the profile. MinPeakProminence rejects small noise dips.
    [~, locs_left] = findpeaks(-profile_left, 'MinPeakProminence', 1000, 'MinPeakDistance', 5);
    num_lines_left = numel(locs_left);

    % --- 3. Analyze Right Side ---
    zone_right_color = extractROI(aligned_color_image, zone_rect_right);
    lab_right = rgb2lab(zone_right_color);
    L_channel_right = lab_right(:,:,1);
    profile_right = sum(L_channel_right, 1);
    
    [~, locs_right] = findpeaks(-profile_right, 'MinPeakProminence', 1000, 'MinPeakDistance', 5);
    num_lines_right = numel(locs_right);

    % --- 4. Calculate Final Score ---
    % The score is high only if we find the correct number of lines (4) on both sides.
    % The ₹100 note has 4 lines on each side.
    if num_lines_left == 4 && num_lines_right == 4
        score = 1.0;
    else
        score = 0.0;
    end
end