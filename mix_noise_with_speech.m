% MATLAB Script for Speech-Noise Mixing at 0 dB SNR
% This script generates speech-in-noise stimuli by mixing clean speech
% recordings with a real-world restaurant noise recording.
%
% Procedure used in the formal experiment:
% 1. Read clean speech .wav files from input_folder.
% 2. Convert speech/noise to mono if needed.
% 3. Scale each speech waveform to a dataset-derived reference standard
%    deviation of 0.0353 before SNR-based noise mixing.
% 4. Extract a duration-matched segment from the same fixed starting point
%    in the restaurant noise recording.
% 5. Scale the noise segment so that its mean squared amplitude matches
%    the speech power, yielding 0 dB SNR.
% 6. Save the mixed speech-in-noise stimulus.

% Folder and file paths
% Replace the placeholder paths below with your own local paths before running the script.
input_folder = 'PATH_TO_SPEECH_FILES';
output_folder = 'PATH_TO_OUTPUT_FOLDER';
noise_file = 'PATH_TO_NOISE_FILE';

% Create output folder if it does not exist
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Read the restaurant noise recording and convert to mono if needed
[noise, noise_fs] = audioread(noise_file);
if size(noise, 2) > 1
    noise = mean(noise, 2);
end

% Get all speech files
audio_files = dir(fullfile(input_folder, '*.wav'));

% Set SNR used in the formal experiment
snr_dB = 0;

% Dataset-derived reference standard deviation for speech waveform scaling
reference_std = 0.0353;

% Fixed starting point for the noise segment, in seconds
fixed_start_time_sec = 5;

for i = 1:length(audio_files)
    fprintf('Processing file %d: %s\n', i, audio_files(i).name);

    % Read speech
    input_path = fullfile(input_folder, audio_files(i).name);
    [speech, Fs] = audioread(input_path);
    if size(speech, 2) > 1
        speech = mean(speech, 2);
    end

    % Check sampling rate consistency
    if Fs ~= noise_fs
        error('Sampling rate mismatch between speech file %s and the noise file.', audio_files(i).name);
    end

    len = length(speech);

    % Extract a fixed-start, duration-matched noise segment
    start_idx = round(fixed_start_time_sec * Fs);
    if (start_idx + len - 1) > length(noise)
        error('Noise file is not long enough to extract a segment of length %d from the fixed starting point.', len);
    end
    noise_segment = noise(start_idx : start_idx + len - 1);

    % Scale speech waveform to the dataset-derived reference standard deviation
    speech_std = std(speech);
    if speech_std == 0
        error('Speech file %s has zero standard deviation and cannot be scaled.', audio_files(i).name);
    end
    speech = speech * reference_std / speech_std;

    % Compute digital signal power as mean squared amplitude
    speech_power = mean(speech.^2);
    desired_noise_power = speech_power / (10^(snr_dB / 10));
    actual_noise_power = mean(noise_segment.^2);
    scaling_factor = sqrt(desired_noise_power / actual_noise_power);
    noise_scaled = noise_segment * scaling_factor;

    % Generate noisy speech
    noisy_signal = speech + noise_scaled;

    % Save output
    [~, name, ext] = fileparts(audio_files(i).name);
    output_name = sprintf('%s_snr0dB%s', name, ext);
    output_path = fullfile(output_folder, output_name);
    audiowrite(output_path, noisy_signal, Fs);
end

disp('All speech files have been processed for fixed-segment 0 dB SNR noise mixing.');
